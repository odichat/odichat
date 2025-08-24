class MigrateExistingContactsToContactInboxes < ActiveRecord::Migration[8.0]
  def up
    # First, we need to create inboxes for existing WhatsApp integrations

    Waba.find_each do |waba|
      # Create WhatsApp channel if it doesn't exist
      whatsapp_channel = Channel::Whatsapp.find_or_create_by(
        chatbot: waba.chatbot,
        phone_number_id: waba.phone_number_id,
        business_account_id: waba.waba_id,
        access_token: waba.access_token,
        subscribed: waba.subscribed
      )

      # Create inbox for this WhatsApp channel
      inbox = Inbox.find_or_create_by(
        chatbot: waba.chatbot,
        channel: whatsapp_channel
      )

      # Migrate existing contacts to ContactInboxes
      waba.chatbot.contacts.find_each do |contact|
        next if contact.phone_number.blank?

        ContactInbox.find_or_create_by(
          contact: contact,
          inbox: inbox,
          source_id: contact.phone_number,
        )
      end

      # Update existing WhatsApp chats to use inbox and contact_inbox
      waba.chatbot.chats.where(source: 'whatsapp').find_each do |chat|
        next unless chat.contact&.phone_number

        contact_inbox = ContactInbox.find_by(
          contact: chat.contact,
          inbox: inbox,
          source_id: chat.contact.phone_number
        )

        if contact_inbox
          chat.update!(
            inbox: inbox,
            contact_inbox: contact_inbox
          )
        end
      end
    end
  end

  def down
    ContactInbox.destroy_all
    Chat.update_all(inbox_id: nil, contact_inbox_id: nil)
  end
end
