module Roleable
  class ProductInventory < ApplicationRecord
    self.table_name = "roleable_product_inventories"

    belongs_to :chatbot
    has_many :products, dependent: :destroy, inverse_of: :product_inventory

    def agent_tools
      [
        Llm::Tools::ProductLookupTool.new
      ]
    end

    def agent_instructions(context)
        # state = context.context[:state]
        # chat_data = state[:chat] || {}
        # contact_data = state[:contact] || {}
        # composed_context = prompt_context.merge(
        #   contact: contact_data
        # )
      <<~INSTRUCTIONS
        You are the Product Inventory Agent. You handle customer queries about product information such as availability, price, or general details.
        **Your tools:**
        #{agent_tools.map { |tool| "- **#{tool.name}**: #{tool.description}" }.join("\n")}

        **Instructions:**
        - Present product information clearly
      INSTRUCTIONS
    end

    def prompt_context
      {
        role: "product_inventory",
        product_count: products.size
      }
    end
  end
end
