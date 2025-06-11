WhatsappSdk.configure do |config|
  # Whatsapp changes the access token every 24 hours.
  # Setting the access token in an ENV variable lets me update the access token
  # without having to redeploy the app from render.com.
  config.access_token = Rails.application.credentials.dig(:whatsapp, :access_token)

  config.api_version = "v21.0" # Whatsapp SDK only supports up until v21.0 in version 1.0.3

  if Rails.env.development?
    config.logger = Logger.new(STDOUT)
    config.logger_options = { bodies: true }
  end
end
