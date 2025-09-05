class Llm::AssistantResponseService < Llm::BaseOpenAiService
  DEFAULT_MODEL = "gpt-4.1-nano-2025-04-14"

  attr_reader :input_message, :input_messages, :system_message, :chat, :chatbot

  def initialize(input_message:, chat:, chatbot:)
    super(model_id: chatbot.model_id)
    @input_message = input_message
    @chat = chat
    @chatbot = chatbot
    register_tools
    @input_messages = build_messages(input_message)
  end

  def generate_response
    parameters = {
      model: DEFAULT_MODEL,
      input: @input_messages,
      tools: @tool_registry&.registered_tools || [],
      previous_response_id: chat.previous_response_id
    }

    # TODO: Clean this up
    # These users are using reasoning models
    if chatbot.user.email.in?(["marketingcodizulca@gmail.com", "soporte.grupopronto@hotmail.com", "admin@odichat.app", "andres@odichat.app"])
      parameters[:text] = { verbosity: "low"}
      parameters[:model] = "gpt-5-mini-2025-08-07"
    end

    response = client.responses.create(parameters: parameters)

    handle_response(response)
  rescue Faraday::BadRequestError => e
    log_error(e, parameters)
    raise "Faraday::BadRequestError: #{e.response.dig(:body)}"
  rescue Faraday::ServerError => e
    log_error(e, parameters)
    raise e
  rescue OpenAI::Error => e
    log_error(e, parameters)
    raise "OpenAI::Error: #{e.message}"
  end

  def handle_response(response)
    update_chat_previous_response_id(response)

    if message_type(response) == "function_call"
      tool_calls = response.dig("output")
      process_tool_calls(tool_calls)
      generate_response
    elsif message_type(response) == "reasoning"
      response_object = response["output"].find { |o| o["type"] == "message" }
      response_message = response_object.dig("content", 0, "text")
      persist_message(response_message, "assistant")
    else
      response_message = response.dig("output", 0, "content", 0, "text") || response.dig("output", 1, "content", 0, "text")
      persist_message(response_message, "assistant")
    end
  end

  def persist_message(response_message, sender = "assistant")
    chat.messages.create!(
      sender: sender,
      message_type: :auto,
      content: response_message,
      inbox: chat.inbox
    )
  end

  def process_tool_calls(tool_calls)
    tool_calls.each do |tool_call|
      process_tool_call(tool_call)
    end
  end

  def process_tool_call(tool_call)
    tool_name = tool_call.dig("name")
    tool_arguments = tool_call.dig("arguments")
    tool_call_id = tool_call.dig("call_id")

    tool_result = @tool_registry.tools[tool_name].execute(tool_arguments)
    append_tool_call_output(tool_call_id, tool_result)
  end

  def append_tool_call_output(tool_call_id, tool_result)
    @input_messages << {
      "type": "function_call_output",
      "call_id": tool_call_id,
      "output": tool_result.to_s
    }
  end

  def register_tools
    @tool_registry = Tools::RegistryService.new
    # TODO: Remove this once we have a way to register tools for each user
    unless chatbot.user.email == "ferronortehomeventas@gmail.com"
      @tool_registry.register_tool(Tools::FromUsdToVesService)
    end
    @tool_registry.register_tool(Tools::FileSearchService, vector_store_id: chatbot.vector_store.vector_store_id)
  end

  def system_message
    # TODO: Clean this up
    if chatbot.user.email.in?(["marketingcodizulca@gmail.com", "soporte.grupopronto@hotmail.com", "admin@odichat.app", "andres@odichat.app"])
      system_instructions = "Formatting re-enabled\n" + chatbot.system_instructions + chatbot.time_aware_instructions + chatbot.additional_system_instructions
    else
      system_instructions = chatbot.system_instructions + chatbot.time_aware_instructions + chatbot.additional_system_instructions
    end

    {
      role: "developer",
      content: system_instructions
    }
  end

  def build_messages(message)
    [
      system_message,
      { role: "user", content: message }
    ]
  end

  def message_type(response)
    response.dig("output", 0, "type")
  end

  def update_chat_previous_response_id(response)
    # If message is older than 24 hours, reset the previous response id
    # We don't want to have memory of previous conversations.
    if should_reset_previous_response_id?
      chat.update!(previous_response_id: nil)
      return
    end

    response_id = response.dig("id")
    chat.update!(previous_response_id: response_id)
  end

  def should_reset_previous_response_id?
    chat.messages.any? && chat.messages.last.created_at < 24.hours.ago
  end

  private

  def log_error(error, parameters = {})
    Rails.logger.error("Error generating assistant response for Chat ##{chat&.id}: #{error.message}")
    Rails.logger.error("Request Parameters: #{parameters.to_json}") if parameters.present?
    Rails.logger.error("Response Body: #{error.response[:body]}") if error.response.present?
    Sentry.capture_exception(error, parameters: { chat_id: chat&.id, user_id: chat&.user.id }.merge(parameters))
  end
end
