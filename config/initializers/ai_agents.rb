require "agents"

Agents.configure do |config|
  config.openai_api_key = Rails.application.credentials.dig(:openai, :access_token)
  # config.anthropic_api_key = Rails.application.credentials.anthropic_api_key
  config.default_model = "gpt-4.1-mini-2025-04-14"
  config.debug = Rails.env.development?
end
