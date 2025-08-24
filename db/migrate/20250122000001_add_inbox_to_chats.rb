class AddInboxToChats < ActiveRecord::Migration[8.0]
  def change
    add_reference :chats, :inbox, null: true, foreign_key: true
    # Keep chatbot_id for now during the transition
    # We'll remove it later once we migrate all data
  end
end
