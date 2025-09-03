class Tools::FromUsdToVesService < Tools::BaseService
  def name
    "convert_price_from_usd_to_ves"
  end

  def description
    "Use this function when the user asks explicitly to convert a USD price to Venezuelan bolivares (VES), e.g. 'cuanto es ese precio en bolivares?', 'cuanto cuesta en bolivares?'. Never call this tool if the user is NOT asking for a price conversion."
  end

  def parameters
    {
      type: "object",
      properties: {
        usd_price: {
          type: "string",
          description: "The price number in USD to convert to Venezuelan bolivares"
        }
      },
      required: [ "usd_price" ],
      additionalProperties: false
    }
  end

  def execute(arguments)
    usd_price_str = JSON.parse(arguments)["usd_price"]

    if usd_price_str.blank?
      Rails.logger.error("No `usd_price` provided when calling `convert_price_from_usd_to_ves` tool")
      return "No `usd_price` provided"
    end

    query = usd_price_str.to_f
    uri = URI.parse("https://ve.dolarapi.com/v1/dolares/oficial")
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      rate = data["promedio"].to_f
      (query * rate).round(2)
    else
      Rails.logger.error("Failed to fetch VES rate: #{response.code} #{response.body}")
      "Error fetching VES rate"
    end
  end
end
