class CreateChatbots < ActiveRecord::Migration[8.0]
  def change
    create_table :chatbots do |t|
      t.string :name, null: false
      t.string :assistant_id, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
