class BackfillConversationSummaryData < ActiveRecord::Migration[8.0]
  def up
    # Using the model is generally discouraged in migrations, but for a one-off
    # backfill like this, it's pragmatic, especially given the complexity of the query.
    Chatbot.find_each do |chatbot|
      # Subquery to get latest message timestamp per contact
      latest_message_times = Message
        .joins(chat: :contact)
        .where(chats: { chatbot_id: chatbot.id, source: "whatsapp" })
        .group("contacts.id")
        .select(
          "contacts.id as contact_id",
          "MAX(messages.created_at) as latest_message_at",
          "MAX(CASE WHEN messages.sender = 'user' THEN messages.created_at ELSE NULL END) as latest_incoming_message_at"
        )

      contacts_with_summary = Contact
        .joins("JOIN (#{latest_message_times.to_sql}) latest_times ON contacts.id = latest_times.contact_id")
        .joins(<<~SQL)
          JOIN messages latest_messages ON latest_messages.id = (
            SELECT m.id FROM messages m
            JOIN chats c ON m.chat_id = c.id
            WHERE c.contact_id = contacts.id
              AND c.chatbot_id = #{chatbot.id}
              AND c.source = 'whatsapp'
            ORDER BY m.created_at DESC
            LIMIT 1
          )
        SQL
        .joins("JOIN chats latest_chats ON latest_chats.id = latest_messages.chat_id")
        .where(chatbot: chatbot)
        .includes(:chats)
        .select(
          "contacts.*,
          latest_times.latest_message_at,
          latest_times.latest_incoming_message_at,
          latest_messages.status as latest_message_status,
          latest_messages.content as latest_message_content,
          latest_messages.chat_id as latest_message_chat_id,
          latest_chats.intervention_enabled as is_latest_chat_intervention_enabled"
        )
        .order("latest_times.latest_message_at DESC")

      contacts_with_summary.each do |contact_summary|
        conversation = contact_summary.conversation
        if conversation
          conversation.update!(
            latest_message_content: contact_summary.latest_message_content,
            latest_message_status: contact_summary.latest_message_status,
            latest_message_at: contact_summary.latest_message_at,
            latest_incoming_message_at: contact_summary.latest_incoming_message_at,
            intervention_enabled: contact_summary.is_latest_chat_intervention_enabled
          )
        end
      end
    end
  end

  def down
    # Revert the backfilled data.
    Conversation.update_all(
      latest_message_content: nil,
      latest_message_status: nil,
      latest_message_at: nil,
      latest_incoming_message_at: nil,
      intervention_enabled: false
    )
  end
end
