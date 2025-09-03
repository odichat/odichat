require 'rails_helper'

RSpec.describe Chatbot, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_one(:waba).dependent(:destroy) }
    it { should have_one(:vector_store).dependent(:destroy) }
    it { should have_one(:shareable_link).dependent(:destroy) }
    it { should have_many(:inboxes).dependent(:destroy) }
    it { should have_many(:chats).dependent(:destroy) }
    it { should have_many(:conversations).dependent(:destroy) }
    it { should have_many(:contacts).dependent(:destroy) }
    it { should have_many(:documents).dependent(:destroy) }
    it { should have_many(:playground_channels).dependent(:destroy).class_name('Channel::Playground') }
    it { should have_many(:public_playground_channels).dependent(:destroy).class_name('Channel::PublicPlayground') }
    it { should have_many(:whatsapp_channels).dependent(:destroy).class_name('Channel::Whatsapp') }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:model_id) }
  end

  describe 'callbacks' do
    describe 'before_create' do
      it 'sets default system instructions' do
        chatbot = create(:chatbot, system_instructions: nil)
        expect(chatbot.system_instructions).to eq('You are a helpful assistant.')
      end

      it 'sets default temperature' do
        chatbot = create(:chatbot, temperature: nil)
        expect(chatbot.temperature).to eq(1.0)
      end
    end

    describe 'after_create' do
      let(:chatbot) { create(:chatbot) }

      it 'creates a shareable link' do
        expect(chatbot.shareable_link).to be_present
      end

      it 'creates a vector store' do
        expect(chatbot.vector_store).to be_present
      end

      it 'creates playground resources' do
        expect(chatbot.playground_channels.count).to eq(1)
        expect(chatbot.playground_inbox).to be_present
        expect(chatbot.last_playground_chat).to be_present
      end

      it 'creates public playground resources' do
        expect(chatbot.public_playground_channels.count).to eq(1)
        expect(chatbot.public_playground_inbox).to be_present
        expect(chatbot.last_public_playground_chat).to be_present
      end
    end

    describe 'after_destroy' do
      it 'enqueues a cleanup job' do
        chatbot = create(:chatbot)
        ActiveJob::Base.queue_adapter = :test
        expect {
          chatbot.destroy
        }.to have_enqueued_job(HandleChatbotCleanupJob)
      end
    end
  end

  describe 'public methods' do
    let(:chatbot) { create(:chatbot) }

    describe '#public_url' do
      it 'returns the public playground url' do
        path = Rails.application.routes.url_helpers.public_playground_path(token: chatbot.shareable_link.token)
        returned_path = URI.parse(chatbot.public_url).path
        expect(returned_path).to eq(path)
      end
    end

    describe '#time_aware_instructions' do
      context 'when chatbot is time aware and has a timezone' do
        it 'returns time aware instructions' do
          chatbot.update!(timezone: 'UTC')
          expect(chatbot.time_aware_instructions).to include('Current time is')
        end
      end

      context 'when chatbot is not time aware' do
        it 'returns an empty string' do
          allow(chatbot).to receive(:is_time_aware?).and_return(false)
          expect(chatbot.time_aware_instructions).to eq('')
        end
      end

      context 'when chatbot has no timezone' do
        it 'returns an empty string' do
          chatbot.update!(timezone: nil)
          expect(chatbot.time_aware_instructions).to eq('')
        end
      end
    end

    describe '#additional_system_instructions' do
      it 'returns instructions to not include citations' do
        expect(chatbot.additional_system_instructions).to include('Do not include documents references or citations')
      end
    end
  end

  describe 'inbox and chat getters' do
    let(:chatbot) { create(:chatbot) }

    it 'returns playground inbox' do
      expect(chatbot.playground_inbox).to be_present
      expect(chatbot.playground_inbox).to eq(chatbot.inboxes.find_by(channel: chatbot.playground_channels.first))
    end

    it 'returns last playground chat' do
      expect(chatbot.last_playground_chat).to be_present
      expect(chatbot.last_playground_chat).to eq(chatbot.playground_inbox.chats.last)
    end

    it 'returns public playground inbox' do
      expect(chatbot.public_playground_inbox).to be_present
      expect(chatbot.public_playground_inbox).to eq(chatbot.inboxes.find_by(channel: chatbot.public_playground_channels.first))
    end

    it 'returns last public playground chat' do
      expect(chatbot.last_public_playground_chat).to be_present
      expect(chatbot.last_public_playground_chat).to eq(chatbot.public_playground_inbox.chats.last)
    end

    context 'with a whatsapp channel' do
      let!(:whatsapp_channel) { create(:channel_whatsapp, chatbot: chatbot) }
      let!(:inbox) { create(:inbox, channel: whatsapp_channel, chatbot: chatbot) }

      it 'returns whatsapp inbox' do
        expect(chatbot.whatsapp_inbox).to eq(inbox)
      end
    end

    context 'without a whatsapp channel' do
      it 'returns nil for whatsapp inbox' do
        chatbot.whatsapp_channels.destroy_all
        expect(chatbot.whatsapp_inbox).to be_nil
      end
    end
  end
end
