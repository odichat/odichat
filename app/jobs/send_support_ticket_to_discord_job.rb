require "discordrb/webhooks"

class SendSupportTicketToDiscordJob < ApplicationJob
  queue_as :default

  def perform(name:, phone_number:, subject:, message:, user_id:)
    webhook_url = Rails.application.credentials.dig(:discord, :webhook_url)

    user = User.find(user_id)

    unless webhook_url.present?
      raise "Discord webhook URL is not set"
    end

    client = Discordrb::Webhooks::Client.new(url: webhook_url)
    client.execute do |builder|
      builder.content = "#{Rails.env.production? ? "Production" : "Test"} — New Support Ticket Submitted by #{user.email} — #{phone_number}"
      builder.add_embed do |embed|
        embed.title = subject
        embed.description = message
      end
    end
  end
end
