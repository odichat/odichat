require "net/http"

class ExchangeTokenAndSubscribeAppJob < ApplicationJob
  queue_as :default

  def perform(chatbot_id, code)
    chatbot = Chatbot.find(chatbot_id)
    whatsapp_channel = chatbot.whatsapp_inbox.channel
    # In development and test environments, we skip the actual token exchange and use a dummy token
    if Rails.env.production?
      access_token = exchange_token(code, chatbot.id)
    else
      access_token = "123456"
    end

    whatsapp_channel.update!(access_token: access_token)

    # In development and test environments, we skip subscribing the app and registering the phone number
    if Rails.env.production?
      subscribe_app(whatsapp_channel)
      register_phone_number(whatsapp_channel)
    end

    # Reload chatbot with associations to ensure fresh data
    chatbot = Chatbot.find(chatbot.id)

    broadcast_flash_message("WhatsApp account connected successfully!", :notice)

    Turbo::StreamsChannel.broadcast_replace_to(
      "integrations",
      target: "whatsapp-card",
      partial: "chatbots/integrations/whatsapp_card",
      locals: {
        chatbot: chatbot
      }
    )
  rescue StandardError => e
    broadcast_flash_message("Error exchanging token and subscribing to app. #{e.message}", :alert)
    raise e
  end

  def exchange_token(code, chatbot_id)
    uri = URI("https://graph.facebook.com/v22.0/oauth/access_token")
    response = Net::HTTP.post(
      uri,
      {
        client_id: Rails.application.credentials.dig(:whatsapp, :app_id),
        client_secret: Rails.application.credentials.dig(:whatsapp, :client_secret),
        code: code,
        grant_type: "authorization_code"
      }.to_json,
      "Content-Type" => "application/json"
    )

    if response.is_a?(Net::HTTPSuccess)
      token_data = JSON.parse(response.body)
      token_data["access_token"]
    else
      raise "Failed to exchange token for chatbot_id #{chatbot_id}: #{response.body}"
    end
  end

  def subscribe_app(whatsapp_channel)
    uri = URI("https://graph.facebook.com/v22.0/#{whatsapp_channel.business_account_id}/subscribed_apps")

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{whatsapp_channel.access_token}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      whatsapp_channel.update!(subscribed: true)
      response
    else
      raise "Failed to subscribe app: #{response.body}"
    end
  rescue StandardError => e
    raise "Error subscribing to app for WABA ID: #{whatsapp_channel.business_account_id}: #{e.message}"
  end

  def register_phone_number(whatsapp_channel)
    uri = URI("https://graph.facebook.com/v22.0/#{whatsapp_channel.phone_number_id}/register")

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{whatsapp_channel.access_token}"
    request["Content-Type"] = "application/json"
    request.body = {
      messaging_product: "whatsapp",
      pin: "000000"
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    unless response.is_a?(Net::HTTPSuccess)
      raise "Failed to register phone number: #{response.body}"
    end

    response
  end

  private

  def broadcast_flash_message(message, type = :notice)
    Turbo::StreamsChannel.broadcast_update_to(
      "integrations",
      target: "flash",
      partial: "shared/flash_messages",
      locals: {
        flash: {
          type => message
        }
      }
    )
  end
end
