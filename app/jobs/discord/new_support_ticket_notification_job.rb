class Discord::NewSupportTicketNotificationJob < ApplicationJob
  queue_as :default

  def perform(name:, phone_number:, subject:, message:, user_id:)
    webhook_url = Rails.application.credentials.dig(:discord, :webhook_url)

    user = User.find(user_id)

    unless webhook_url.present?
      raise "Discord webhook URL is not set"
    end

    client = Discordrb::Webhooks::Client.new(url: webhook_url)
    client.execute do |builder|
      builder.content = <<~CONTENT
        ## New Support Ticket
        - Environment: **#{Rails.env.production? ? "Production" : "Test"}**
        - User Name: **#{name}**
        - Email: **#{user.email}**
        - Phone Number: **#{phone_number}**
      CONTENT
      builder.add_embed do |embed|
        embed.title = subject
        embed.description = message
      end
    end
  end
end
