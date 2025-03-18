class CreateChats < ActiveRecord::Migration[8.0]
  def change
    create_table :chats do |t|
      t.references :chatbot, null: false, foreign_key: true
      t.string :contact_phone
      t.string :thread_id, null: false
      t.string :source, null: false

      t.timestamps
    end
  end
end
