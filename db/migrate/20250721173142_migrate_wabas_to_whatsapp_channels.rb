class MigrateWabasToWhatsappChannels < ActiveRecord::Migration[8.0]
  def up
    migrated_count = 0

    Waba.includes(:chatbot).find_each do |waba|
      # Skip if this chatbot already has a WhatsApp channel with the same phone_number_id
      next if waba.chatbot.whatsapp_channels.exists?(phone_number_id: waba.phone_number_id)

      # Create the WhatsApp channel
      whatsapp_channel = Channel::Whatsapp.create!(
        chatbot: waba.chatbot,
        phone_number_id: waba.phone_number_id,
        business_account_id: waba.waba_id,
        access_token: waba.access_token,
        subscribed: waba.subscribed || false
      )

      # Create the corresponding inbox
      inbox = Inbox.create!(
        chatbot: waba.chatbot,
        channel: whatsapp_channel
      )

      # Update any existing WhatsApp chats that don't have an inbox_id
      whatsapp_chats = waba.chatbot.chats.where(source: "whatsapp", inbox_id: nil)
      whatsapp_chats.update_all(inbox_id: inbox.id)

      # Update messages in these chats to reference the inbox
      message_ids = whatsapp_chats.pluck(:id)
      if message_ids.any?
        Message.where(chat_id: message_ids, inbox_id: nil).update_all(inbox_id: inbox.id)
      end

      migrated_count += 1
    end

    puts "Migrated #{migrated_count} Wabas to WhatsApp channels with inboxes"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Cannot reverse migration from Wabas to WhatsApp channels"
  end
end
