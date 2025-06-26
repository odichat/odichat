class RemoveContactPhoneFromChats < ActiveRecord::Migration[8.0]
  def change
    remove_column :chats, :contact_phone, :string
  end
end
