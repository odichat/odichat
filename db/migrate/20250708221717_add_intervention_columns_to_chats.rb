class AddInterventionColumnsToChats < ActiveRecord::Migration[8.0]
  def change
    add_column :chats, :intervention_enabled, :boolean, default: false, null: false
    add_column :chats, :intervened_at, :datetime
  end
end
