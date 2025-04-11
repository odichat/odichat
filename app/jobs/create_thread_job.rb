class CreateThreadJob < ApplicationJob
  queue_as :default

  retry_on OpenAI::Error, wait: :polynomially_longer, attempts: 5, priority: :high
  after_discard do |job, exception|
    chat = Chat.find_by(id: job.arguments.first)
    return unless chat&.source == "whatsapp"
    Rails.logger.error("Final failure for chat_id: #{chat.id} after retries: #{exception.class} - #{exception.message}")

    message = "Sorry, the service is currently unavailable. Please try again later."
    WhatsappService.send_message(chat.chatbot.waba.waba_id, chat.contact_phone, message)
  end

  def perform(chat_id)
    chat = Chat.find(chat_id)
    chat.create_thread!
    broadcast_messages(chat) if chat.source == "playground"
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Chat not found for chat_id: #{chat_id} (#{e.message})")
    notify_whatsapp(chat) if chat&.source == "whatsapp"
  rescue StandardError => e
    Rails.logger.error("Error creating thread for chat_id: #{chat_id} (#{e.message})")
    raise
  end

  private

  def broadcast_messages(chat)
    Turbo::StreamsChannel.broadcast_replace_to(
      "messages",
      target: "loader",
      partial: "chatbots/playground/chat_messages",
      locals: {
        messages: chat.messages || []
      }
    )
  end

  def notify_whatsapp(job, exception)
    chat = Chat.find_by(id: job.arguments.first)
    return unless chat&.source == "whatsapp"
    Rails.logger.error("Final failure for chat_id: #{chat.id} after retries: #{exception.class} - #{exception.message}")

    message = "Sorry, the service is currently unavailable. Please try again later."
    WhatsappService.send_message(chat.chatbot.waba.waba_id, chat.contact_phone, message)
  end
end
