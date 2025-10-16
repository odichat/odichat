module Agentable
  extend ActiveSupport::Concern

  def agent
    Agents::Agent.new(
      name: agent_name,
      instructions: ->(context) { agent_instructions(context) },
      tools: agent_tools,
      model: agent_model,
      temperature: agent_temperature.to_f,
      response_schema: agent_response_schema
    )
  end

  private

    def agent_name
      raise NotImplementedError, "#{self.class} must implement agent_name"
    end

    def agent_model
      Agents.configuration.default_model
    end

    def agent_temperature
      raise NotImplementedError, "#{self.class} must implement agent_temperature"
    end

    def agent_instructions(context = nil)
      raise NotImplementedError, "#{self.class} must implement agent_instructions"
    end

    def prompt_context
      raise NotImplementedError, "#{self.class} must implement prompt_context"
    end

    def agent_tools
      []
    end

    def agent_response_schema
      nil
    end
end
