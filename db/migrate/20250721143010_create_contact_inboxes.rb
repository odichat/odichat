class CreateContactInboxes < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_inboxes do |t|
      t.references :contact, null: false, foreign_key: true
      t.references :inbox, null: false, foreign_key: true
      t.string :source_id, null: false
      t.timestamps
    end
  end
end
