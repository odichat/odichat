class Discord::NewUserNotificationJob < ApplicationJob
  queue_as :default

  def perform(user:)
    webhook_url = Rails.application.credentials.dig(:discord, :webhook_url)

    unless webhook_url.present?
      raise "Discord webhook URL is not set"
    end

    client = Discordrb::Webhooks::Client.new(url: webhook_url)
    client.execute do |builder|
      builder.content = <<~CONTENT
        ## New User Registered
        - Email: **#{user.email}**
      CONTENT
    end
  end
end
