require "rails_helper"

RSpec.describe Llm::Tools::FileSearchTool do
  subject(:tool) { described_class.new }

  let(:tool_context) { instance_double("ToolContext", state: { chatbot_id: chatbot_id }) }
  let(:chatbot_id) { chatbot.id }
  let(:chatbot) { create(:chatbot) }

  before do
    allow(CreateVectorStoreJob).to receive(:perform_later)
  end

  describe "#perform" do
    context "when the chatbot cannot be resolved" do
      let(:chatbot_id) { nil }

      it "returns an informative message" do
        response = tool.perform(tool_context, query: "billing")
        expect(response).to eq("Document search is not available for this chatbot")
      end
    end

    context "when the chatbot does not have a vector store" do
      it "returns a configuration message" do
        response = tool.perform(tool_context, query: "pricing")
        expect(response).to eq("Document search is not configured for this chatbot")
      end
    end

    context "when the chatbot has a vector store" do
      let!(:vector_store) { create(:vector_store, chatbot: chatbot, vector_store_id: "vs_123") }
      let(:responses_resource) { instance_double("OpenAIResponses", create: response_payload) }
      let(:client) { instance_double(OpenAI::Client, responses: responses_resource) }
      let(:response_payload) do
        {
          "output" => [
            {
              "type" => "message",
              "content" => [
                { "type" => "output_text", "text" => "Here is the answer you need." }
              ]
            }
          ]
        }
      end

      before do
        allow(OpenAI::Client).to receive(:new).and_return(client)
      end

      it "queries OpenAI with the file_search tool and returns the response text" do
        response = tool.perform(tool_context, query: "Where is my order?")

        expect(response).to eq("Here is the answer you need.")
        expect(responses_resource).to have_received(:create).with(
          parameters: hash_including(
            :model,
            tools: [
              hash_including(
                type: "file_search",
                vector_store_ids: [ "vs_123" ]
              )
            ],
            input: array_including(
              hash_including(
                role: "developer",
                content: array_including(hash_including(text: include("DocumentSearchGPT")))
              ),
              hash_including(
                role: "user",
                content: array_including(hash_including(text: "Where is my order?"))
              )
            )
          )
        )
      end
    end
  end
end
