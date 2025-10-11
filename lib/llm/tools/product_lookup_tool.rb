class Llm::Tools::ProductLookupTool < Agents::Tool
  description "Search products using semantic similarity to find relevant products"
  param :query, type: :string, desc: "The question about the product to search for in the products database"

  def name
    "product_lookup"
  end

  def perform(tool_context, query:)
  end
end
