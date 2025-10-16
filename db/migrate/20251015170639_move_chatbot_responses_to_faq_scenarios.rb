class MoveChatbotResponsesToFaqScenarios < ActiveRecord::Migration[8.0]
  def change
    add_reference :responses, :scenario, null: false, foreign_key: true, index: true
    remove_reference :responses, :chatbot, foreign_key: true
  end
end
