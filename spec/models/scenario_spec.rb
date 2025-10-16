require 'rails_helper'

RSpec.describe Scenario, type: :model do
  describe '#destroy' do
    it 'removes the associated roleable record' do
      chatbot = create(:chatbot)
      roleable = Roleable::ProductInventory.create!(chatbot: chatbot)

      scenario = described_class.create!(
        chatbot: chatbot,
        name: 'Inventory',
        description: 'Handles product queries',
        roleable: roleable
      )

      scenario.destroy

      expect(Roleable::ProductInventory.find_by(id: roleable.id)).to be_nil
    end
  end
end
