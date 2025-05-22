class CreateShareableLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :shareable_links do |t|
      t.references :chatbot, null: false, foreign_key: true
      t.string :token

      t.timestamps
    end
  end
end
