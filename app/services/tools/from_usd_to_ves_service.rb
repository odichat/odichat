class Tools::FromUsdToVesService < Tools::BaseService
  def name
    "convert_price_from_usd_to_ves"
  end

  def description
    "Use this function when the user asks you to convert a USD price to Venezuelan bolivares (VES)(also known as Bs)."
  end

  def parameters
    {
      type: "object",
      properties: {
        usd_price: {
          type: "string",
          description: "The price number in USD to convert to Venezuelan bolivares (VES)(also known as Bs)",
        }
      },
      required: ["usd_price"],
      additionalProperties: false
    }
  end

  def execute(arguments)
    query = JSON.parse(arguments)["usd_price"].to_f
    uri = URI.parse("https://ve.dolarapi.com/v1/dolares/oficial")
    response = Net::HTTP.get_response(uri)

    if query.present? && response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      rate = data["promedio"].to_f
      (query * rate).round(2)
    elsif query.blank?
      Rails.logger.error("No `usd_price` provided when calling `convert_price_from_usd_to_ves` tool")
      "No `usd_price` provided"
    else
      Rails.logger.error("Failed to fetch VES rate: #{response.code} #{response.body}")
      "Error fetching VES rate"
    end
  end
end
