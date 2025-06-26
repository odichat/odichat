class BackfillContactIdInChats < ActiveRecord::Migration[8.0]
  def up
    Chat.find_each do |chat|
      next if chat.contact_phone.blank?

      contact = Contact.find_by(
        chatbot_id: chat.chatbot_id,
        phone_number: chat.contact_phone
      )

      chat.update_column(:contact_id, contact.id) if contact
    end
  end

  def down
  end
end
