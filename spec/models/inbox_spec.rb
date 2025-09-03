require 'rails_helper'

RSpec.describe Inbox, type: :model do
  describe 'associations' do
    it { should belong_to(:chatbot) }
    it { should belong_to(:channel) }
    it { should have_many(:contact_inboxes).dependent(:destroy) }
    it { should have_many(:contacts).through(:contact_inboxes) }
    it { should have_many(:chats).dependent(:destroy) }
    it { should have_many(:messages).dependent(:destroy) }
  end

  describe 'methods' do
    describe '#whatsapp_channel?' do
      it 'returns true if the channel is a Channel::Whatsapp' do
        inbox = create(:inbox, :whatsapp)
        expect(inbox.whatsapp_channel?).to be(true)
      end

      it 'returns false if the channel is not a Channel::Whatsapp' do
        inbox = create(:inbox, :playground)
        expect(inbox.whatsapp_channel?).to be(false)
      end
    end

    describe '#playground_channel?' do
      it 'returns true if the channel is a Channel::Playground' do
        inbox = create(:inbox, :playground)
        expect(inbox.playground_channel?).to be(true)
      end

      it 'returns false if the channel is not a Channel::Playground' do
        inbox = create(:inbox, :whatsapp)
        expect(inbox.playground_channel?).to be(false)
      end
    end

    describe '#public_playground_channel?' do
      it 'returns true if the channel is a Channel::PublicPlayground' do
        inbox = create(:inbox, :public_playground)
        expect(inbox.public_playground_channel?).to be(true)
      end

      it 'returns false if the channel is not a Channel::PublicPlayground' do
        inbox = create(:inbox, :whatsapp)
        expect(inbox.public_playground_channel?).to be(false)
      end
    end
  end
end