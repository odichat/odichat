require 'rails_helper'

RSpec.describe Chat, type: :model do
  describe 'associations' do
    it { should belong_to(:chatbot) }
    it { should belong_to(:inbox) }
    it { should belong_to(:contact_inbox).optional }
    it { should belong_to(:contact).optional }
    it { should belong_to(:conversation).optional }
    it { should have_many(:messages).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:source) }
    it { should validate_presence_of(:inbox_id) }
  end

  describe 'methods' do
    let(:whatsapp_inbox) { create(:inbox, :whatsapp) }
    let(:playground_inbox) { create(:inbox, :playground) }
    let(:public_playground_inbox) { create(:inbox, :public_playground) }

    describe '#whatsapp_channel?' do
      it 'returns true if the inbox is a whatsapp channel' do
        chat = create(:chat, inbox: whatsapp_inbox)
        expect(chat.whatsapp_channel?).to be(true)
      end

      it 'returns false if the inbox is not a whatsapp channel' do
        chat = create(:chat, inbox: playground_inbox)
        expect(chat.whatsapp_channel?).to be(false)
      end
    end

    describe '#playground_channel?' do
      it 'returns true if the inbox is a playground channel' do
        chat = create(:chat, inbox: playground_inbox)
        expect(chat.playground_channel?).to be(true)
      end

      it 'returns false if the inbox is not a playground channel' do
        chat = create(:chat, inbox: whatsapp_inbox)
        expect(chat.playground_channel?).to be(false)
      end
    end

    describe '#public_playground_channel?' do
      it 'returns true if the inbox is a public_playground channel' do
        chat = create(:chat, inbox: public_playground_inbox)
        expect(chat.public_playground_channel?).to be(true)
      end

      it 'returns false if the inbox is not a public_playground channel' do
        chat = create(:chat, inbox: whatsapp_inbox)
        expect(chat.public_playground_channel?).to be(false)
      end
    end
  end
end
