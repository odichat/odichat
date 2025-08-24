class AddContactInboxToChats < ActiveRecord::Migration[8.0]
  def change
    add_reference :chats, :contact_inbox, null: true, foreign_key: true
  end
end
