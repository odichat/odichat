class CreateVectorStores < ActiveRecord::Migration[8.0]
  def change
    create_table :vector_stores do |t|
      t.references :chatbot, null: false, foreign_key: true
      t.string :vector_store_id

      t.timestamps
    end
  end
end
