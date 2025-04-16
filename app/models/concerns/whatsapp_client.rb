module WhatsappClient
  extend ActiveSupport::Concern

  VERSION = "v21.0".freeze

  included do
    def whatsapp_client(access_token = nil)
      bodies = Rails.env.local? ? { bodies: true } : {}
      @whatsapp_client ||= WhatsappSdk::Api::Client.new(access_token || Rails.application.credentials.dig(:whatsapp, :access_token), VERSION, Logger.new(STDOUT), bodies)
    end
  end
end
