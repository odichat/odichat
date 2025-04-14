class RemoveAssistantIdAndVectorStoreIdFromChatbots < ActiveRecord::Migration[8.0]
  def change
    remove_column :chatbots, :assistant_id
    remove_column :chatbots, :vector_store_id
  end
end
