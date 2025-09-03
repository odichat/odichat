require 'rails_helper'

RSpec.describe ShareableLink, type: :model do
  describe 'associations' do
    it { should belong_to(:chatbot) }
  end

  describe 'validations' do
    subject { create(:shareable_link) }
    it { should validate_uniqueness_of(:token) }
  end
end
