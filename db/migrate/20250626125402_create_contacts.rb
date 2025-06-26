class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.references :chatbot, null: false, foreign_key: true
      t.string :phone_number, null: false
      t.string :name

      t.timestamps
    end

    add_index :contacts, [ :chatbot_id, :phone_number ], unique: true
  end
end
