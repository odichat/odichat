class RemoveThreadIdFromChats < ActiveRecord::Migration[8.0]
  def change
    remove_column :chats, :thread_id
  end
end
