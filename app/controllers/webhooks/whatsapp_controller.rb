class Webhooks::WhatsappController < ApplicationController
  skip_before_action :verify_authenticity_token
  def verify
    mode =      params["hub.mode"]
    token =     params["hub.verify_token"]
    challenge = params["hub.challenge"]

    if mode == "subscribe" && token == Rails.application.credentials.dig(:whatsapp, :webhook_verify_token)
      render json: challenge, status: :ok
    else
      render json: { error: "Invalid verification token" }, status: :unauthorized
    end
  end

  def process_payload
    Webhooks::WhatsappEventsJob.perform_later(params.to_unsafe_hash)
    head :ok
  end
end
