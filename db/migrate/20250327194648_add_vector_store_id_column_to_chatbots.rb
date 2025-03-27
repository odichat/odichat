class AddVectorStoreIdColumnToChatbots < ActiveRecord::Migration[8.0]
  def change
    add_column :chatbots, :vector_store_id, :string
  end
end
