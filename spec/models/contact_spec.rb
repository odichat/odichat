require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'associations' do
    it { should belong_to(:chatbot) }
    it { should have_one(:conversation) }
    it { should have_many(:contact_inboxes) }
    it { should have_many(:inboxes) }
    it { should have_many(:chats) }
  end

  describe 'validations' do
    subject { build(:contact) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_uniqueness_of(:phone_number).scoped_to(:chatbot_id).case_insensitive }
  end
end
