class Llm::Tools::FaqLookupTool < Agents::Tool
  description "Search FAQ responses using semantic similarity to find relevant answers"
  param :query, type: :string, desc: "The question or topic to search for in the FAQ database"

  def name
    "faq_lookup"
  end

  def perform(tool_context, query:)
    chatbot_id = tool_context.state.dig(:chatbot_id)
    @agent = Chatbot.find_by(id: chatbot_id)

    faq_scenario = Roleable::Faq.find_by(chatbot_id: @agent.id) if @agent.present?

    log_tool_usage("searching", { query: query })

    responses = faq_scenario&.responses&.search(query)

    if responses.present?
      log_tool_usage("found_results", { query: query, count: responses.size })
      format_responses(responses)
    else
      log_tool_usage("no_results", { query: query })
      "No relevant FAQ responses found for #{query}"
    end
  end

  private

    def format_responses(responses)
      response = responses.map { |r| "Q: #{r.question}\nA: #{r.answer}" }.join("\n\n")
      response
    end

    def log_tool_usage(action, details = {})
      Rails.logger.info do
        "#{self.class.name}: #{action} for agent #{@agent&.id} - #{details.inspect}"
      end
      puts "#{self.class.name}: #{action} for agent #{@agent&.id} - #{details.inspect}"
    end
end
