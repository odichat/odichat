module WhatsappClient
  extend ActiveSupport::Concern

  VERSION = "v21.0".freeze

  included do
    def whatsapp_client(access_token = nil)
      bodies = Rails.env.local? ? { bodies: true } : {}
      @whatsapp_client ||= WhatsappSdk::Api::Client.new(access_token || ENV["WHATSAPP_ACCESS_TOKEN"], VERSION, Logger.new(STDOUT), bodies)
    end
  end
end
