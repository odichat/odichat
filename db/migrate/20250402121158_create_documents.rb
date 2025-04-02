class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.references :chatbot, null: false, foreign_key: true
      t.string :file_id

      t.timestamps
    end
  end
end
