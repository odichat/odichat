OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.dig(:openai, :access_token)
  config.organization_id = Rails.application.credentials.dig(:openai, :organization_id)
  # config.admin_token = ENV.fetch("OPENAI_ADMIN_TOKEN") # Optional, used for admin endpoints, created here: https://platform.openai.com/settings/organization/admin-keys
  # config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID") # Optional
  config.log_errors = Rails.env.development? # Set to true in development, false in production to avoid leaking private data to logs.
end
