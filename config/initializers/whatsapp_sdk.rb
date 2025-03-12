WhatsappSdk.configure do |config|
  # Whatsapp changes the access token every 24 hours.
  # Setting the access token in an ENV variable lets me update the access token
  # without having to redeploy the app from render.com.
  config.access_token = ENV["WHATSAPP_ACCESS_TOKEN"]

  # config.api_version = API_VERSION

  config.logger = Logger.new(STDOUT) # optional, Faraday logger to attach
  config.logger_options = { bodies: true } # optional, they are all valid logger_options for Faraday
end
