class BackfillContactsFromChats < ActiveRecord::Migration[8.0]
  def up
    Chat.find_each do |chat|
      next if chat.contact_phone.blank?
      Contact.find_or_create_by!(
        chatbot_id: chat.chatbot_id,
        phone_number: chat.contact_phone
      )
    end
  end

  def down
  end
end
