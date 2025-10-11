class Chatbot::AgentRunnerService
  CONTACT_STATE_ATTRIBUTES = %i[ name phone_number ].freeze

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
      chatbot_agent = @chatbot.agent
      [ chatbot_agent ]
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
