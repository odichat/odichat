class AddContactIdToChats < ActiveRecord::Migration[8.0]
  def change
    add_reference :chats, :contact, foreign_key: true
  end
end
