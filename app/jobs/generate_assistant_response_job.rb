class GenerateAssistantResponseJob < ApplicationJob
  queue_as :default

  retry_on OpenAI::Error, wait: 10.seconds, attempts: 3, priority: :high, jitter: 0.25

  def perform(message_id)
    client = OpenAI::Client.new do |f|
      f.response :logger, Logger.new($stdout), bodies: true
    end
    user_message = Message.includes(:chat).find(message_id)
    chat = user_message.chat
    chatbot = chat.chatbot
    model = Model.find(chatbot.model_id)

    # Appends the time aware instructions to the system instructions
    # If the chatbot is not time aware, nothing is appended
    system_instructions = chatbot.system_instructions + chatbot.time_aware_instructions
    input_messages = [
      {
        role: "developer",
        content: system_instructions
      },
      {
        role: "user",
        content: user_message.content
      }
    ]

    response = client.responses.create(parameters: {
      model: model.name,
      input: input_messages,
      tools: [
        {
          type: "file_search",
          vector_store_ids: [ chatbot.vector_store.vector_store_id ]
        },
        get_price_in_usd_from_ves_json
      ],
      previous_response_id: chat.previous_response_id
    })

    raise OpenAI::Error, "No response from OpenAI" if response["id"].blank?
    chat.update!(previous_response_id: response["id"])

    response_content = response.dig("output", 0, "content", 0, "text") || response.dig("output", 1, "content", 0, "text") || response.dig("output", 0, "type")

    if response_content.include?("function_call")
      tool_call = response.dig("output", 0)
      fn_name = response.dig("output", 0, "name")

      if fn_name == "get_price_in_ves_from_usd"
        fn_args = JSON.parse(response.dig("output", 0, "arguments"))["usd_price"]
        ves_price = get_price_in_ves_from_usd(fn_args)
        input_messages << {
          "type": "function_call_output",
          "call_id": tool_call["call_id"],
          "output": ves_price.to_s
        }

        response = client.responses.create(parameters: {
          model: model.name,
          input: input_messages,
          tools: [
            {
              type: "file_search",
              vector_store_ids: [ chatbot.vector_store.vector_store_id ]
            },
            get_price_in_usd_from_ves_json
          ],
          previous_response_id: chat.previous_response_id
        })

        raise OpenAI::Error, "No response from OpenAI" if response["id"].blank?
        chat.update!(previous_response_id: response["id"])

        response_content = response.dig("output", 0, "content", 0, "text") || response.dig("output", 1, "content", 0, "text") || response.dig("output", 0, "type")
      end
    end

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

  private

  def get_price_in_ves_from_usd(usd_price)
    uri = URI.parse("https://ve.dolarapi.com/v1/dolares/oficial")
    response = Net::HTTP.get_response(uri)

    binding.break

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      rate = data["promedio"].to_f
      (usd_price.to_f * rate).round(2)
    else
      Rails.logger.error("Failed to fetch VES rate: #{response.code} #{response.body}")
      nil
    end
  end

  def get_price_in_usd_from_ves_json
    {
      "type": "function",
      "name": "get_price_in_ves_from_usd",
      "description": "Use this function when the user asks you to convert a USD price to Venezuelan bolivares (VES).",
      "parameters": {  # Format: https://json-schema.org/understanding-json-schema
        "type": "object",
        "properties": {
          "usd_price": {
            "type": "string",
            "description": "The price number in USD to convert to Venezuelan bolivares (VES",
          }
        },
        "required": ["usd_price"],
        "additionalProperties": false
      }
    }
  end
end
