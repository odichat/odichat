require 'rails_helper'

RSpec.describe ContactInbox, type: :model do
  describe 'associations' do
    it { should belong_to(:contact) }
    it { should belong_to(:inbox) }
    it { should have_many(:chats).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create(:contact_inbox) }
    it { should validate_presence_of(:source_id) }
    it { should validate_uniqueness_of(:source_id).scoped_to(:inbox_id).case_insensitive }
  end
end
