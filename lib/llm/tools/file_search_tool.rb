class Llm::Tools::FileSearchTool < Agents::Tool
  description "Searches the chatbot knowledge"
  param :query, type: :string, desc: "Question or topic to search for in the chatbot documents"

  def name
    "file_search"
  end

  def perform(tool_context, query:)
    chatbot = resolve_chatbot(tool_context)
    return "Document search is not available for this chatbot" unless chatbot

    vector_store_id = chatbot.vector_store&.vector_store_id
    return "Document search is not configured for this chatbot" if vector_store_id.blank?

    log_tool_usage("searching_file_search_tool", query: query)

    response = openai_client.responses.create(parameters: build_parameters(query, vector_store_id))
    text_response = extract_text_response(response)

    if text_response && !text_response.empty?
      log_tool_usage("found_results", query: query)
      text_response
    else
      log_tool_usage("no_results", query: query)
      "No relevant information found for '#{query}'."
    end
  rescue OpenAI::Error => e
    log_tool_usage("error", query: query, error: e.message)
    Rails.logger.error("#{self.class.name} failed: #{e.message}")
    "Document search failed due to an upstream OpenAI error."
  rescue StandardError => e
    log_tool_usage("error", query: query, error: e.message)
    Rails.logger.error("#{self.class.name} unexpected failure: #{e.message}\n#{e.backtrace.join("\n")}")
    "Document search failed."
  end

  private

  def resolve_chatbot(tool_context)
    chatbot_id = tool_context.state.dig(:chatbot_id)
    return nil if chatbot_id.blank?

    @agent = Chatbot.includes(:vector_store).find_by(id: chatbot_id)
  end

  def openai_client
    @openai_client ||= OpenAI::Client.new
  end

  def build_parameters(query, vector_store_id)
    {
      model: "gpt-4o-mini-2024-07-18",
      input: [
        developer_message,
        user_message(query)
      ],
      tools: [
        {
          type: "file_search",
          vector_store_ids: [ vector_store_id ]
        }
      ]
    }
  end

  def developer_message
    {
      role: "developer",
      content: "You are DocumentSearchGPT. Your only job is to read the user's query," \
               " use the file_search tool to retrieve relevant passages from the chatbot's documents," \
               " and return a concise answer grounded in those passages. Do not rely on outside knowledge."
    }
  end

  def user_message(query)
    {
      role: "user",
      content: query
    }
  end

  def extract_text_response(response)
    outputs = response.is_a?(Hash) ? Array(response["output"]) : []
    message_block = outputs.reverse.find { |block| block["type"] == "message" }
    return "" unless message_block

    content_items = Array(message_block["content"])
    content_items.filter_map { |item| item["text"] }.join("\n").strip
  end

  def log_tool_usage(action, details = {})
    Rails.logger.info do
      "#{self.class.name}: #{action} for agent #{@agent&.id} - #{details.inspect}"
    end
    puts "#{self.class.name}: #{action} for agent #{@agent&.id} - #{details.inspect}"
  end
end
