class AddNameColumnToVectorStore < ActiveRecord::Migration[8.0]
  def change
    add_column :vector_stores, :name, :string
  end
end
