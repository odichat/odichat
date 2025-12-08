module InstagramConcern
  extend ActiveSupport::Concern

  def instagram_client
    ::OAuth2::Client.new(
      client_id,
      client_secret,
      {
        site: "https://api.instagram.com",
        authorize_url: "https://api.instagram.com/oauth/authorize",
        token_url: "https://api.instagram.com/oauth/access_token",
        auth_scheme: :request_body,
        token_method: :post
      }
    )
  end

  private

  def client_id
    Rails.application.credentials.dig(:instagram, :client_id)
  end

  def client_secret
    Rails.application.credentials.dig(:instagram, :client_secret)
  end

  def exchange_for_long_lived_token(short_lived_token)
    endpoint = "https://graph.instagram.com/access_token"
    params = {
      grant_type: "ig_exchange_token",
      client_secret: client_secret,
      access_token: short_lived_token,
      client_id: client_id
    }

    make_api_request(endpoint, params, "Failed to exchange token")
  end

  def fetch_instagram_user_details(access_token)
    endpoint = "https://graph.instagram.com/v22.0/me"
    params = {
      fields: "id,username,user_id,name,profile_picture_url,account_type",
      access_token: access_token
    }

    make_api_request(endpoint, params, "Failed to fetch Instagram user details")
  end

  def make_api_request(endpoint, params, error_prefix)
    log_instagram_request(endpoint, params)

    response = HTTParty.get(
      endpoint,
      query: params,
      headers: { "Accept" => "application/json" }
    )

    log_instagram_response(endpoint, response)

    unless response.success?
      Rails.logger.error "#{error_prefix}. Status: #{response.code}, Body: #{response.body}"
      raise "#{error_prefix}: #{response.body}"
    end

    begin
      JSON.parse(response.body)
    rescue JSON::ParserError => e
      ChatwootExceptionTracker.new(e).capture_exception
      Rails.logger.error "Invalid JSON response: #{response.body}"
      raise e
    end
  end

  def base_url
    Rails.application.credentials.dig(:instagram, :base_url)
  end

  def log_instagram_request(endpoint, params)
    safe_params = filter_sensitive_params(params)
    Rails.logger.info("[InstagramConnect] Requesting #{endpoint} with params #{safe_params}")
  end

  def log_instagram_response(endpoint, response)
    Rails.logger.info("[InstagramConnect] Response from #{endpoint} status=#{response.code}")
  end

  def filter_sensitive_params(params)
    params.each_with_object({}) do |(key, value), filtered|
      if key.to_s.match?(/token|secret|code/i)
        filtered[key] = "[FILTERED]"
      else
        filtered[key] = value
      end
    end
  end
end
