class GenerateAssistantResponseJob < ApplicationJob
  queue_as :default

  retry_on OpenAI::Error, wait: 10.seconds, attempts: 3, priority: :high, jitter: 0.25

  def perform(message_id)
    user_message = Message.includes(:chat).find(message_id)
    chat = user_message.chat
    thread_id = chat.thread_id

    OpenAiService.add_message_to_thread(thread_id, user_message.sender, user_message.content)
    assistant_message = OpenAiService.create_and_wait_for_run(thread_id, chat.assistant_id)

    assistant_message = chat.messages.create!(
      sender: "assistant",
      content: assistant_message
    )

    Rails.logger.info("About to broadcast assistant message: #{assistant_message.id}")

    case chat.source
    when "playground"
      Turbo::StreamsChannel.broadcast_append_to(
        "messages",
        target: "playground-messages",
        partial: "messages/message",
        locals: { message: assistant_message }
      )
    when "whatsapp"
      WhatsappService.send_message(chat.chatbot.waba.waba_id, chat.contact_phone, assistant_message.content)
    else
      raise "Unknown chat source: #{chat.source}"
    end
  rescue StandardError => e
    Rails.logger.error("Error adding message to chat_id: #{user_message.chat.id} and thread_id: #{thread_id}: #{e.message}")
    # TODO: Send a notification to the user
    raise "Error adding message to chat_id: #{user_message.chat.id} and thread_id: #{thread_id}: #{e.message}"
  end
end
