class Scenario < ApplicationRecord
  include ToolsHelper
  include Agentable

  validates :name, presence: true
  validates :description, presence: true
  validates :instruction, presence: true
  validates :chatbot_id, presence: true
  validate :validate_instruction_tools

  belongs_to :chatbot

  def agent_name
    name
  end

  def agent_temperature
    0.5.to_f
  end

  def agent_instructions(context = nil)
    if context.present?
      state = context.context[:state] || {}
      _conversation_data = state[:conversation] || {}
      _contact_data = state[:contact] || {}

      self.instruction
    end
  end

  def agent_tools
    resolved_tools.map { |tool| self.class.resolve_tool_class(tool[:id]) }.map { |tool| tool.new }
  end

  def agent_response_schema
    Chatbot::ResponseSchema
  end

  def resolved_tools
    return [] if tools.blank?

    available_tools = self.class.available_agent_tools
    tools.filter_map do |tool_id|
      available_tools.find { |tool| tool[:id] == tool_id }
    end
  end

  def validate_instruction_tools
    return if instruction.blank?

    tool_ids = extract_tool_ids_from_text(instruction)
    return if tool_ids.empty?

    available_tool_ids = self.class.available_tool_ids
    invalid_tools = tool_ids - available_tool_ids

    return unless invalid_tools.any?

    errors.add(:instruction, "contains invalid tools: #{invalid_tools.join(', ')}")
  end

  # Resolves tool references from the instruction text into the tools field.
  # Parses the instruction for tool references and materializes them as
  # tool IDs stored in the tools JSONB field.
  #
  # @return [void]
  # @api private
  # @example
  #   scenario.instruction = "First [@Add Private Note](tool://add_private_note) then [@Update Priority](tool://update_priority)"
  #   scenario.save!
  #   scenario.tools # => ["add_private_note", "update_priority"]
  #
  #   scenario.instruction = "No tools mentioned here"
  #   scenario.save!
  #   scenario.tools # => nil
  def resolve_tool_references
    return if instruction.blank?

    tool_ids = extract_tool_ids_from_text(instruction)
    self.tools = tool_ids.presence
  end
end
