module Roleable
  class Faq < ApplicationRecord
    self.table_name = "roleable_faqs"

    belongs_to :chatbot
    has_many :responses, dependent: :destroy, inverse_of: :faq

    def agent_tools
      [
        Llm::Tools::FaqLookupTool.new
      ]
    end

    def agent_instructions(_context = nil)
      <<~INSTRUCTIONS
        You are the FAQ Agent. Answer frequently asked questions using the curated knowledge base.
        **Your tools:**
        #{agent_tools.map { |tool| "- **#{tool.name}**: #{tool.description}" }.join("\n")}

        **Instructions:**
        - Provide concise, helpful answers.
        - If the knowledge base does not cover the query, acknowledge the limitation.
      INSTRUCTIONS
    end

    def prompt_context
      {
        role: "faq"
      }
    end
  end
end
