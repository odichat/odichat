class AddPreviousResponseIdToChats < ActiveRecord::Migration[8.0]
  def change
    add_column :chats, :previous_response_id, :string, null: true, default: nil
  end
end
