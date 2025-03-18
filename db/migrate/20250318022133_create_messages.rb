class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.string :sender
      t.string :wa_message_id
      t.string :assistant_message_id
      t.text :content

      t.timestamps
    end
  end
end
