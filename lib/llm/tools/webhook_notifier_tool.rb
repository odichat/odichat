class Llm::Tools::WebhookNotifierTool < Agents::Tool
  description "Triggers and sends a webhook notification"
  # param :query, type: :string, desc: "The question about the product to search for in the products database"

  def name
    "webhook_notifier"
  end

  def perform(tool_context)
    chatbot_id = tool_context.state.dig(:chatbot_id)
    @agent = Chatbot.find_by(id: chatbot_id)

    puts "****************************************"
    puts "WEBHOOK TOOL RAN"
    puts "****************************************"
  end

  private

    def log_tool_usage(action, details = {})
      Rails.logger.info do
        "#{self.class.name}: #{action} for agent #{@agent&.id} - #{details.inspect}"
      end
      puts "#{self.class.name}: #{action} for agent #{@agent&.id} - #{details.inspect}"
    end
end
