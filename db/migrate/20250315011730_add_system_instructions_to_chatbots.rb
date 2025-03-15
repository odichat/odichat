class AddSystemInstructionsToChatbots < ActiveRecord::Migration[8.0]
  def change
    add_column :chatbots, :system_instructions, :string, null: true
  end
end
