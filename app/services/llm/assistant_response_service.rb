class Llm::AssistantResponseService < Llm::BaseOpenAiService
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
    response = client.responses.create(
      parameters: {
        model: model.name,
        input: @input_messages,
        tools: @tool_registry&.registered_tools || [],
        previous_response_id: chat.previous_response_id
      }
    )

    handle_response(response)
  end

  def handle_response(response)
    update_chat_previous_response_id(response)

    if message_type(response) == "function_call"
      tool_calls = response.dig("output")
      process_tool_calls(tool_calls)
      generate_response
    else
      response_message = response.dig("output", 0, "content", 0, "text") || response.dig("output", 1, "content", 0, "text")
      persist_message(response_message, "assistant")
    end
  end

  def persist_message(response_message, sender = "assistant")
    chat.messages.create!(
      sender: sender,
      content: response_message
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
    @tool_registry.register_tool(Tools::FromUsdToVesService)
    @tool_registry.register_tool(Tools::FileSearchService, vector_store_id: chatbot.vector_store.vector_store_id)
  end

  def system_message
    system_instructions = chatbot.system_instructions + chatbot.time_aware_instructions
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
    response_id = response.dig("id")
    chat.update!(previous_response_id: response_id)
  end
end
