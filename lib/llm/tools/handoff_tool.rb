class Llm::Tools::HandoffTool < Agents::Tool
  description "Initiate a handoff to a human agent"
  param :reason, type: :string, desc: "The reason why the handoff is needed (optional)", required: false

  def name
    "handoff"
  end

  def perform(tool_context, reason: nil)
    log_tool_usage("initiating_handoff", { reason: reason || "Agent requested handoff" })
    # TODO
    puts "****************"
    puts "Handoff to human agent initiated."
    puts "****************"

    "Handoff to human agent initiated. #{reason.present? ? "Reason: #{reason}" : ''}"
  end

  private

    def log_tool_usage(action, details = {})
      Rails.logger.info do
        "#{self.class.name}: #{action} for assistant #{@assistant&.id} - #{details.inspect}"
      end
    end
end
