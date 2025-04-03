module OpenaiClient
  extend ActiveSupport::Concern

  included do
    def openai_client
      @openai_client ||= ::OpenAI::Client.new(
        access_token: Rails.env.local? ? ENV["OPENAI_ACCESS_TOKEN"] : ENV["OPENAI_ACCESS_TOKEN"],
        log_errors: Rails.env.local?
      )
    end
  end

  class_methods do
    def openai_client
      @openai_client ||= ::OpenAI::Client.new(
        access_token: Rails.env.local? ? ENV["OPENAI_ACCESS_TOKEN"] : ENV["OPENAI_ACCESS_TOKEN"],
        log_errors: Rails.env.local?
      )
    end
  end
end
