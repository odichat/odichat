require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe "associations" do
    it { should belong_to(:chatbot) }
    it { should belong_to(:contact) }
    it { should have_many(:chats).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:chatbot_id) }
    it { should validate_presence_of(:contact_id) }
  end

  describe "scopes" do
    describe ".ordered_by_latest" do
      it "orders conversations by latest_message_at in descending order" do
        conversation1 = create(:conversation, latest_message_at: 1.day.ago)
        conversation2 = create(:conversation, latest_message_at: Time.current)

        expect(Conversation.ordered_by_latest).to eq([conversation2, conversation1])
      end
    end
  end

  describe "#latest_message_status" do
    it "returns nil if the status is blank" do
      conversation = build(:conversation, latest_message_status: nil)
      expect(conversation.latest_message_status).to be_nil
    end

    it "returns a StringInquirer for the status" do
      conversation = build(:conversation, latest_message_status: "sent")
      expect(conversation.latest_message_status).to be_a(ActiveSupport::StringInquirer)
      expect(conversation.latest_message_status.sent?).to be true
      expect(conversation.latest_message_status.delivered?).to be false
    end
  end

  describe "intervention toggles" do
    let(:conversation) { create(:conversation, intervention_enabled: false) }

    describe "#enable_intervention!" do
      it "enables intervention" do
        conversation.enable_intervention!
        expect(conversation.intervention_enabled?).to be true
      end
    end

    describe "#disable_intervention!" do
      it "disables intervention" do
        conversation.update(intervention_enabled: true)
        conversation.disable_intervention!
        expect(conversation.intervention_enabled?).to be false
      end
    end

    describe "#toggle_intervention!" do
      context "when intervention is disabled" do
        it "enables intervention" do
          conversation.update(intervention_enabled: false)
          conversation.toggle_intervention!
          expect(conversation.intervention_enabled?).to be true
        end
      end

      context "when intervention is enabled" do
        it "disables intervention" do
          conversation.update(intervention_enabled: true)
          conversation.toggle_intervention!
          expect(conversation.intervention_enabled?).to be false
        end
      end
    end
  end

  describe "#whatsapp_reply_window_open?" do
    context "when the latest incoming message is within 24 hours" do
      it "returns true" do
        conversation = build(:conversation, latest_incoming_message_at: 23.hours.ago)
        expect(conversation.whatsapp_reply_window_open?).to be true
      end
    end

    context "when the latest incoming message is older than 24 hours" do
      it "returns false" do
        conversation = build(:conversation, latest_incoming_message_at: 25.hours.ago)
        expect(conversation.whatsapp_reply_window_open?).to be false
      end
    end

    context "when there is no incoming message" do
      it "returns false" do
        conversation = build(:conversation, latest_incoming_message_at: nil)
        expect(conversation.whatsapp_reply_window_open?).to be false
      end
    end
  end
end
