class Chatbot::AgentRunnerService
  CONTACT_STATE_ATTRIBUTES = %i[ id name phone_number ].freeze
  CONVERSATION_STATE_ATTRIBUTES = %i[ id contact_id ]

  def initialize(chatbot:, chat:)
    @chatbot = chatbot
    @chat = chat
  end

  def generate_response(message_history: [])
    agents = build_and_wire_agents
    context = build_context(message_history)
    message_to_process = extract_last_user_message_to_process(message_history)
    runner = Agents::Runner.with_agents(*agents)
    # TODO: Add callbacks, but first, what are callbacks?
    result = runner.run(message_to_process, context: context)

    process_agent_result(result.output)
  end

  private

    def build_and_wire_agents
      triage_agent = @chatbot.agent
      scenario_agents = @chatbot.scenarios.map(&:agent)

      triage_agent.register_handoffs(*scenario_agents) if scenario_agents.any?
      scenario_agents.each { |scenario_agent| scenario_agent.register_handoffs(triage_agent) }
      [ triage_agent ] + scenario_agents
    end

    def build_context(message_history)
      chat_history = message_history.map do |msg|
        {
          role: msg[:role],
          content: msg[:content]
        }
      end

      {
        chat_history: chat_history,
        state: build_state
      }
    end

    def build_state
      state = {
        chatbot_id: @chatbot.id
      }

      state[:contact] = @chat.contact&.attributes&.symbolize_keys&.slice(*CONTACT_STATE_ATTRIBUTES)
      state[:conversation] = @chat.conversation&.attributes&.symbolize_keys&.slice(*CONVERSATION_STATE_ATTRIBUTES)

      state
    end

    def extract_last_user_message_to_process(message_history)
      # message_history comes sorted in asc order from response_builder_job
      message_history.reverse.find { |msg| msg[:role] == "user" }
    end

    def process_agent_result(output)
      return output.with_indifferent_access if output.is_a?(Hash)

      {
        "response": output.to_s,
        "reasoning": nil
      }
    end
end
