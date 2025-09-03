require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'associations' do
    it { should belong_to(:chat) }
    it { should belong_to(:inbox).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:sender) }
    it { should validate_inclusion_of(:sender).in_array(%w[user assistant]) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values({ sent: 0, delivered: 1, read: 2, failed: 3 }).backed_by_column_of_type(:integer) }
    it { should define_enum_for(:message_type).with_values({ auto: 0, manual: 1 }).backed_by_column_of_type(:integer) }
  end

  describe 'scopes' do
    let!(:assistant_manual) { create(:message, sender: 'assistant', message_type: :manual) }
    let!(:assistant_auto)   { create(:message, sender: 'assistant', message_type: :auto) }
    let!(:user_msg)         { create(:message, sender: 'user',      message_type: nil) }
    let!(:assistant_nil)    { create(:message, sender: 'assistant', message_type: nil) }

    it 'returns messages with assistant message type manual' do
      expect(described_class.manual).to include(assistant_manual)
      expect(described_class.manual).not_to include(assistant_auto, user_msg, assistant_nil)
    end

    it 'returns messages with assistant message type auto' do
      expect(described_class.automated).to include(assistant_auto)
      expect(described_class.automated).not_to include(assistant_manual, user_msg, assistant_nil)
    end
  end

  describe '#assistant?' do
    subject(:message) { build(:message, sender: sender) }

    context 'when sender is assistant' do
      let(:sender) { 'assistant' }
      it  { is_expected.to be_assistant }
      it { is_expected.not_to be_user }
    end
  end

  describe '#user?' do
    subject(:message) { build(:message, sender: sender) }

    context 'when the sender is user' do
      let(:sender) { 'user' }
      it { is_expected.to be_user }
      it { is_expected.not_to be_assistant }
    end
  end

  describe 'after_create_commit' do
    include ActiveJob::TestHelper

    let(:conversation) { create(:conversation) }
    let(:chat) { create(:chat, conversation: conversation) }

    before { clear_enqueued_jobs }

    context 'when message sender is user' do
      it 'enqueues Llm::AssistantResponseJob if intervention is NOT enabled' do
        msg = create(:message, chat: chat, sender: 'user', content: 'hi')
        expect(Llm::AssistantResponseJob).to have_been_enqueued.with(msg.id)
        expect(SendReplyJob).not_to have_been_enqueued
      end

      it 'does NOT enqueue Llm::AssistantResponseJob if intervention IS enabled' do
        allow(conversation).to receive(:intervention_enabled?).and_return(true)
        _msg = create(:message, chat: chat, sender: 'user', content: 'hi')
        expect(Llm::AssistantResponseJob).to_not have_been_enqueued
      end
    end

    context 'when sender is assistant' do
      it 'enqueues SendReplyJob' do
        msg = create(:message, chat: chat, sender: 'assistant', content: 'hello')
        expect(SendReplyJob).to have_been_enqueued.with(msg.id)
        expect(Llm::AssistantResponseJob).to_not have_been_enqueued
      end
    end

    # TODO: After reviewing different approaches on how to implement this test
    # I turned very complex to do. So I realized the message.rb model is doing too much
    #   1. Broadcasting UI updates
    #   2. Enqueuing background jobs
    #   3. Updateing associated Conversation record
    # The easiest way to refactor this to make tests on the model more lean and the Message model solely
    # responsible for message data and it's immediate associations is to implement
    # a Service Object `MessageEvents::OnCreate` `MessageEvents::OnUpdate` or `MessageProcessorService`
    # or something along those lines to move all those points mentioned above to that Service Object
    # and then test the Service Object in isolation, mock dependencies, and it also makes it more manteinable
    it 'updates conversation record', pending: true
  end
end
