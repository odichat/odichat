class Scenario < ApplicationRecord
  include Agentable

  validates :name, presence: true
  validates :description, presence: true
  validates :chatbot_id, presence: true
  validates :roleable, presence: true

  belongs_to :chatbot
  belongs_to :roleable, polymorphic: true

  def agent_name
    name
  end

  def agent_temperature
    0.5.to_f
  end

  def agent_instructions(context = nil)
    return "" unless roleable.respond_to?(:agent_instructions)

    roleable.agent_instructions(context)
  end

  def prompt_context
    base_context = {
      name: name,
      description: description
    }

    role_context =
      if roleable.respond_to?(:prompt_context)
        roleable.prompt_context
      else
        {}
      end

    base_context.merge(role_context)
  end

  def agent_tools
    if roleable.respond_to?(:agent_tools)
      roleable.agent_tools
    else
      []
    end
  end
end
