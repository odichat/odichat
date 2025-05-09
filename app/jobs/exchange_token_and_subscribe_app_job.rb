require "net/http"

class ExchangeTokenAndSubscribeAppJob < ApplicationJob
  queue_as :default

  def perform(chatbot_id, code)
    chatbot = Chatbot.find(chatbot_id)
    waba = chatbot.waba
    raise "Waba not found for chatbot #{chatbot.id}" if waba.nil?

    access_token = exchange_token(code)
    waba.update!(access_token: access_token)

    subscribe_app(waba)
    register_phone_number(waba)

    # Reload chatbot with associations to ensure fresh data
    chatbot = Chatbot.includes(:waba).find(chatbot.id)

    Turbo::StreamsChannel.broadcast_update_to(
      "integrations",
      target: "flash",
      partial: "shared/flash_messages",
      locals: {
        flash: {
          notice: "WhatsApp account connected successfully!"
        }
      }
    )

    Turbo::StreamsChannel.broadcast_replace_to(
      "integrations",
      target: "waba-card",
      partial: "chatbots/integrations/waba_card",
      locals: {
        chatbot: chatbot
      }
    )
  rescue StandardError => e
    Turbo::StreamsChannel.broadcast_update_to(
      "integrations",
      target: "flash",
      partial: "shared/flash_messages",
      locals: {
        flash: {
          alert: "Error exchanging token and subscribing to app. #{e.message}"
        }
      }
    )
  end

  def exchange_token(code)
    uri = URI("https://graph.facebook.com/v22.0/oauth/access_token")
    response = Net::HTTP.post(
      uri,
      {
        client_id: "1293328758418096",
        client_secret: "118934e47bceb3e1eb3079dfabd493d5",
        code: code,
        grant_type: "authorization_code"
      }.to_json,
      "Content-Type" => "application/json"
    )

    if response.is_a?(Net::HTTPSuccess)
      token_data = JSON.parse(response.body)
      token_data["access_token"]
    else
      raise "Failed to exchange token for chatbot #{chatbot.id}: #{response.body}"
    end
  end

  def subscribe_app(waba)
    uri = URI("https://graph.facebook.com/v22.0/#{waba.waba_id}/subscribed_apps")

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{waba.access_token}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      waba.update!(subscribed: true)
      response
    else
      raise "Failed to subscribe app: #{response.body}"
    end
  rescue StandardError => e
    raise "Error subscribing to app for WABA ID: #{waba.waba_id}: #{e.message}"
  end

  def register_phone_number(waba)
    uri = URI("https://graph.facebook.com/v22.0/#{waba.phone_number_id}/register")

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{waba.access_token}"
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
end
