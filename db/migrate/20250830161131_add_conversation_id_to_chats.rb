class AddConversationIdToChats < ActiveRecord::Migration[8.0]
  def change
    add_reference :chats, :conversation, null: true, foreign_key: true

    # Create conversations for existing chats
    Chat.where(source: "whatsapp").each do |chat|
      conversation = Conversation.find_or_create_by!(chatbot: chat.chatbot, contact: chat.contact)
      chat.update!(conversation_id: conversation.id)
    end
  end
end
