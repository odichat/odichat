class Scenario < ApplicationRecord
  include Agentable

  validates :name, presence: true
  validates :description, presence: true
  validates :instruction, presence: true
  validates :chatbot_id, presence: true

  belongs_to :chatbot

  def agent_name
    name
  end

  def agent_temperature
    0.5.to_f
  end

  def agent_instructions(context = nil)
    instruction
  end

  def prompt_context
    {
      name: name,
      description: description
    }
  end

  def agent_tools
    [
      Llm::Tools::ProductLookupTool.new
    ]
  end
end
