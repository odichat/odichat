class CreateThreadJob < ApplicationJob
  queue_as :default

  def perform(chat_id)
    chat = Chat.find(chat_id)
    thread_id = OpenAiService.create_thread
    chat.update!(thread_id: thread_id)

    Turbo::StreamsChannel.broadcast_replace_to(
      "messages",
      target: "playground_chat",
      partial: "chatbots/playground/chat",
      locals: {
        chat: chat,
        messages: chat.messages || [],
        chatbot: chat.chatbot,
        is_loading: false
      }
    )
  rescue StandardError => e
    Rails.logger.error("Error creating thread for chat_id: #{chat_id}: #{e.message}")
    raise "Error creating thread for chat_id: #{chat_id}: #{e.message}"
  end
end
