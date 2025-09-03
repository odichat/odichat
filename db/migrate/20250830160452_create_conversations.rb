class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.references :chatbot, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: true

      t.text :latest_message_content
      t.string :latest_message_status
      t.timestamp :latest_message_at
      t.timestamp :latest_incoming_message_at
      t.boolean :intervention_enabled, default: false, null: false

      t.timestamps
    end
  end
end
