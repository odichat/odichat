module OpenaiClient
  extend ActiveSupport::Concern

  included do
    def openai_client
      @openai_client ||= ::OpenAI::Client.new(
        access_token: Rails.application.credentials.openai[:access_token],
        log_errors: Rails.env.local?
      )
    end
  end

  class_methods do
    def openai_client
      @openai_client ||= ::OpenAI::Client.new(
        access_token: Rails.application.credentials.openai[:access_token],
        log_errors: Rails.env.local?
      )
    end
  end
end
