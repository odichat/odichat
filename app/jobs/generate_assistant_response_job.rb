class GenerateAssistantResponseJob < ApplicationJob
  queue_as :default

  retry_on OpenAI::Error, wait: 10.seconds, attempts: 3, priority: :high, jitter: 0.25

  def perform(message_id)
    client = OpenAI::Client.new
    user_message = Message.includes(:chat).find(message_id)
    chat = user_message.chat
    chatbot = chat.chatbot
    model = Model.find(chatbot.model_id)

    # Appends the time aware instructions to the system instructions
    # If the chatbot is not time aware, nothing is appended
    system_instructions = chatbot.system_instructions + chatbot.time_aware_instructions

    response = client.responses.create(parameters: {
      model: model.name,
      input: [
        {
          role: "developer",
          content: system_instructions
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

    raise OpenAI::Error, "No response from OpenAI" if response["id"].blank?
    chat.update!(previous_response_id: response["id"])

    response_content = response.dig("output", 0, "content", 0, "text") || response.dig("output", 1, "content", 0, "text")
    assistant_message = chat.messages.create!(
      sender: "assistant",
      content: response_content
    )

    Rails.logger.info("About to broadcast assistant message: #{assistant_message.id}")

    case chat.source
    when "playground"
      Turbo::StreamsChannel.broadcast_append_to(
        "chat_#{chat.id}_messages",
        target: "messages",
        partial: "messages/message",
        locals: { message: assistant_message }
      )
    when "public_playground"
      Turbo::StreamsChannel.broadcast_append_to(
        "public_chat_#{chat.id}_messages",
        target: "messages",
        partial: "public/messages/message",
        locals: { message: assistant_message }
      )
    when "whatsapp"
      WhatsappService.send_message(chat.chatbot.waba.waba_id, chat.contact_phone, assistant_message.content)
    else
      raise "Unknown chat source: #{chat.source}"
    end
  rescue Faraday::TooManyRequestsError => e
    Rails.logger.error("Too many requests to OpenAI: #{e.message}")
    Sentry.capture_exception(e)
    # TODO: Notify Odichat's discord channel about the error
  rescue WhatsappSdk::Api::Responses::HttpResponseError => e
    error_details = {
      message: e.message,
      response_code: e.try(:response_code),
      response_body: e.try(:response_body),
      waba_id: chatbot.waba.waba_id
    }
    Rails.logger.error("WhatsApp API Error: #{error_details.to_json}")
    Sentry.capture_exception(e, extra: error_details)
  end
end
