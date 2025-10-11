class CreateResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :responses do |t|
      t.references :chatbot, null: false, foreign_key: true
      t.string :question
      t.string :answer
      t.vector :embedding, limit: 1536

      t.timestamps
    end
  end
end
