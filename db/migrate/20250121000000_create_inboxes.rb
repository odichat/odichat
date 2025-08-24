class CreateInboxes < ActiveRecord::Migration[8.0]
  def change
    create_table :inboxes do |t|
      t.references :chatbot, null: false, foreign_key: true
      t.references :channel, polymorphic: true, null: false

      t.timestamps
    end
  end
end
