require "rails_helper"

RSpec.describe Llm::BaseOpenAiService do
  subject(:service) { described_class.new(model_id: model_id) }

  let(:openai_client) { instance_double(OpenAI::Client) }
  let!(:default_model) { create(:model, name: "gpt-5-mini-2025-08-07") }
  let(:model_id) { nil }

  before do
    allow(OpenAI::Client).to receive(:new).and_return(openai_client)
  end

  describe "#initialize" do
    context "when a model_id is provided" do
      let(:custom_model) { create(:model, name: "gpt-5-nano") }
      let(:model_id) { custom_model.id }

      it "initializes with the specified model" do
        expect(service.model).to eq(custom_model)
      end

      it "initializes the OpenAI client" do
        expect(service.client).to eq(openai_client)
        expect(OpenAI::Client).to have_received(:new)
      end
    end

    context "when a model_id is not provided" do
      let(:model_id) { nil }

      it "initializes with the default model" do
        expect(service.model).to eq(default_model)
      end

      it "initializes the OpenAI client" do
        expect(service.client).to eq(openai_client)
        expect(OpenAI::Client).to have_received(:new)
      end
    end

    context "when an invalid model_id is provided" do
      let(:model_id) { 9999 }

      it "initializes with the default model" do
        expect(service.model).to eq(default_model)
      end
    end

    context "when OpenAI client initialization fails" do
      before do
        allow(OpenAI::Client).to receive(:new).and_raise("API Key not found")
      end

      it "raises an error" do
        expect { service }.to raise_error("Failed to initialize OpenAI client: API Key not found")
      end
    end
  end
end
