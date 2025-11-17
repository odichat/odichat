class Llm::Tools::CreateLeadTool < Agents::Tool
  description "Creates a lead record when lead creation/collection criteria is met"
  param :trigger, type: :string, desc: "A short and brief description of the rational to create the lead, i.e., purchasing intent for [product/service X]"

  def name
    "create_lead"
  end

  def perform(tool_context, trigger:)
    chatbot_id = tool_context.state.dig(:chatbot_id)
    contact = tool_context.state.dig(:contact)

    # No contact, no conversation in playgrounds, so we halt tool execution.
    return if contact.nil?

    @agent = Chatbot.find_by(id: chatbot_id)

    @agent.leads.create!(
      contact_id: contact[:id],
      trigger: trigger
    )

    puts "****************************************"
    puts "CREATE LEAD TOOL RAN"
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
