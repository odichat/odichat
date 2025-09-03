require "rails_helper"

RSpec.describe Whatsapp::SendMessageService do
  let(:access_token) { "test_token" }
  let(:sender_id) { "12345" }
  let(:recipient_number) { "67890" }
  let(:message) { "Hello, world!" }
  let(:whatsapp_client) { instance_double(WhatsappSdk::Api::Client) }
  let(:messages_api) { instance_double(WhatsappSdk::Api::Messages) }

  before do
    allow(WhatsappSdk::Api::Client).to receive(:new).with(access_token, "v21.0", anything, anything).and_return(whatsapp_client)
    allow(whatsapp_client).to receive(:messages).and_return(messages_api)
  end

  describe "#send_message" do
    subject(:send_message) do
      described_class.new(access_token: access_token).send_message(
        sender_id: sender_id,
        recipient_number: recipient_number,
        message: message
      )
    end

    context "when the message is sent successfully" do
      it "calls the send_text method on the messages api" do
        expect(messages_api).to receive(:send_text).with(
          sender_id: sender_id,
          recipient_number: recipient_number,
          message: message
        )
        send_message
      end
    end

    context "when the API returns a DisplayNameApprovalError" do
      let(:error_message) { '{"error":{"code":131037}}' }
      let(:error) do
        WhatsappSdk::Api::Responses::HttpResponseError.new(
          http_status: 400,
          body: error_message
        )
      end

      it "raises a DisplayNameApprovalError", pending: true
    end

    context "when the API returns a generic error" do
      let(:error) { WhatsappSdk::Api::Responses::HttpResponseError.new(http_status: 500, body: "Some other error") }

      it "raises the original error" do
        allow(messages_api).to receive(:send_text).and_raise(error)
        expect { send_message }.to raise_error(WhatsappSdk::Api::Responses::HttpResponseError)
      end
    end
  end

  describe "#initialize" do
    context "when an access token is provided" do
      it "initializes the client with the provided token" do
        expect(WhatsappSdk::Api::Client).to receive(:new).with(access_token, "v21.0", anything, anything)
        described_class.new(access_token: access_token)
      end
    end

    context "when an access token is not provided" do
      let(:default_token) { "default_token" }

      before do
        allow(Rails.application.credentials).to receive(:dig).with(:whatsapp, :access_token).and_return(default_token)
      end

      it "initializes the client with the default token" do
        expect(WhatsappSdk::Api::Client).to receive(:new).with(default_token, "v21.0", anything, anything)
        described_class.new
      end
    end
  end
end
