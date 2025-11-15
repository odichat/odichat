class Llm::Tools::ProductLookupTool < Agents::Tool
  description "Search products using semantic similarity to find relevant products"
  param :query, type: :string, desc: "The question about the product to search for in the products database"

  def name
    "product_lookup"
  end

  def perform(tool_context, query:)
    chatbot_id = tool_context.state.dig(:chatbot_id)
    @agent = Chatbot.find_by(id: chatbot_id)

    log_tool_usage("searching", { query: query })

    products = @agent&.products&.search(query)

    if products.present?
      log_tool_usage("found_results", { query: query, count: products.size })
      format_products(products)
    else
      log_tool_usage("no_results", { query: query })
      "No relevant products found for #{query}"
    end
  end

  private

    def format_products(products)
      products.map { |p| "Name: #{p.name}\nDescription: #{p.description}\nPrice: #{p.price}" }.join("\n\n")
    end

    def log_tool_usage(action, details = {})
      Rails.logger.info do
        "#{self.class.name}: #{action} for agent #{@agent&.id} - #{details.inspect}"
      end
      puts "#{self.class.name}: #{action} for agent #{@agent&.id} - #{details.inspect}"
    end
end
