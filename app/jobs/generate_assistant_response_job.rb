class GenerateAssistantResponseJob < ApplicationJob
  queue_as :default

  retry_on OpenAI::Error, wait: 10.seconds, attempts: 3, priority: :high, jitter: 0.25

  def perform(message_id)
    client = OpenAI::Client.new
    user_message = Message.includes(:chat).find(message_id)
    chat = user_message.chat
    chatbot = chat.chatbot
    model = Model.find(chatbot.model_id)

    response = client.responses.create(parameters: {
      model: model.name,
      input: [
        {
          role: "developer",
          content: chatbot.system_instructions
        },
        {
          role: "user",
          content: user_message.content
        }
      ],
      tools: [
        {
          type: "file_search",
          vector_store_ids: [ chatbot.vector_store.vector_store_id ]
        }
      ],
      previous_response_id: chat.previous_response_id
    })

    # TODO: Raise when no response["id"] comes back
    chat.update!(previous_response_id: response["id"])

    assistant_message = chat.messages.create!(
      sender: "assistant",
      content: response.dig("output", 0, "content", 0, "text")
    )

    Rails.logger.info("About to broadcast assistant message: #{assistant_message.id}")

    case chat.source
    when "playground"
      Turbo::StreamsChannel.broadcast_append_to(
        "messages",
        target: "messages",
        partial: "messages/message",
        locals: { message: assistant_message }
      )
    when "whatsapp"
      WhatsappService.send_message(chat.chatbot.waba.waba_id, chat.contact_phone, assistant_message.content)
    else
      raise "Unknown chat source: #{chat.source}"
    end
  rescue StandardError => e
    Rails.logger.error("Error adding message to chat_id: #{user_message.chat.id}: #{e.message}")
    # TODO: Send a notification to the user
    raise "Error adding message to chat_id: #{user_message.chat.id}: #{e.message}"
  end
end
