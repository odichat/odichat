class HandleInboundMessageJob < ApplicationJob
  queue_as :default

  def perform(message_data)
    waba = Waba.includes(:chatbot).find_by!(waba_id: message_data[:waba_id])
    chatbot = waba.chatbot
    chat = chatbot.chats.includes(:messages).find_by(contact_phone: message_data[:from_phone_number])

    if chat.nil?
      chat = chatbot.chats.create!(contact_phone: message_data[:from_phone_number], source: "whatsapp")
      CreateThreadJob.perform_now(chat.id) # Will insert the thread_id to the chat
    end

    message = chat.messages.create!(sender: "user", content: message_data[:message_text])
    GenerateAssistantResponseJob.perform_later(message.id)
  rescue StandardError => e
    Rails.logger.error("Error handling inbound message: #{e.message}")
    # TODO: Send a notification to the user
    raise "Error handling inbound message: #{e.message}"
  end
end
