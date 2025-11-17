class Scenario < ApplicationRecord
  include ToolsHelper
  include Agentable

  TOOL_SECTION_HEADER = "**Your tools:**".freeze
  TOOL_SECTION_REGEX = /(\*\*Your tools:\*\*\n)(.*?)(?=\n\*\*|\z)/m

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

  def tool_ids
    Array.wrap(tools)
  end

  def update_tools!(new_tool_ids)
    # The `&` single ampersand keeps only elements present in both arrays, each listed once
    # This ensures only valid tool IDs are assigned
    # e.g., ["faq_lookup", "invalid_tool"] & ["faq_lookup", "product_lookup"] => ["faq_lookup"]
    valid_ids = Array.wrap(new_tool_ids).map(&:to_s) & self.class.available_tool_ids
    self.tools = valid_ids.presence
    refresh_instruction_tools_section!
    save!
  end

  def add_tool!(tool_id)
    update_tools!(tool_ids | [ tool_id ])
  end

  def remove_tool!(tool_id)
    update_tools!(tool_ids - [ tool_id ])
  end

  def refresh_instruction_tools_section!
    tool_section = render_tool_section
    body = instruction.to_s

    if body.match?(TOOL_SECTION_REGEX)
      self.instruction = body.sub(TOOL_SECTION_REGEX) do
        if tool_section.present?
          "#{Regexp.last_match(1)}#{tool_section}\n"
        else
          ""
        end
      end
    elsif tool_section.present?
      insertion = "#{TOOL_SECTION_HEADER}\n#{tool_section}\n\n"
      self.instruction = body.present? ? "#{body.rstrip}\n\n#{insertion}" : insertion
    else
      self.instruction = body
    end
  end

  def render_tool_section
    resolved_tools.map do |tool|
      "- [@#{tool[:title]}](tool://#{tool[:id]}) — #{tool[:description]}"
    end.join("\n")
  end
end
