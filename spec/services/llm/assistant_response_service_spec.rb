require "rails_helper"

RSpec.describe Llm::AssistantResponseService do
  describe "#initialize" do
    let(:user) { create(:user) }
    let!(:model) { create(:model, name: "gpt-4.1-nano-2025-04-14") }
    let(:vector_store) { create(:vector_store) }
    let(:chatbot) { create(:chatbot,
             user: user,
             model_id: model.id,
             vector_store: vector_store,
             system_instructions: "system instructions") }
    let(:chat) { create(:chat, chatbot: chatbot) }
    let(:input_message) { "Hello, world!" }
    let(:tool_registry_instance) { instance_double(Tools::RegistryService, register_tool: nil) }

    subject(:service) { described_class.new(
        input_message: input_message,
        chat: chat,
        chatbot: chatbot
      ) }

    before do
      allow(Tools::RegistryService).to receive(:new).and_return(tool_registry_instance)
      allow(OpenAI::Client).to receive(:new).and_return(instance_double(OpenAI::Client))
    end

    it "initializes the base service with the chatbot's model" do
      expect(service.model).to eq(model)
    end

    it "assigns the input_message" do
      expect(service.input_message).to eq(input_message)
    end

    it "assigns the chat" do
      expect(service.chat).to eq(chat)
    end

    it "assigns the chatbot" do
      expect(service.chatbot).to eq(chatbot)
    end

    it "registers the tools", pending: true do
      service # trigger initialization
      expect(Tools::RegistryService).to have_received(:new)
      expect(tool_registry_instance).to have_received(:register_tool).with(Tools::FromUsdToVesService)
      expect(tool_registry_instance).to have_received(:register_tool).with(Tools::FileSearchService, vector_store_id: vector_store.vector_store_id)
    end

    describe "#build_messages" do
      it "constructs messages with the aggregated system instructions from the chatbot" do
        aggregated_instructions = "These are the aggregated instructions."
        allow(chatbot).to receive(:aggregated_system_instructions).and_return(aggregated_instructions)

        # Re-initialize service to use the stub
        service = described_class.new(input_message: input_message, chat: chat, chatbot: chatbot)

        expected_system_message = {
          role: "developer",
          content: aggregated_instructions
        }
        expected_messages = [
          expected_system_message,
          { role: "user", content: input_message }
        ]

        expect(service.input_messages).to eq(expected_messages)
        expect(chatbot).to have_received(:aggregated_system_instructions)
      end
    end

    context "with a special user for register_tools", pending: true do
      let(:user) { create(:user, email: "ferronortehomeventas@gmail.com") }

      it "does not register FromUsdToVesService" do
        service
        expect(tool_registry_instance).not_to have_received(:register_tool).with(Tools::FromUsdToVesService)
        expect(tool_registry_instance).to have_received(:register_tool).with(Tools::FileSearchService, vector_store_id: vector_store.vector_store_id)
      end
    end
  end
end
