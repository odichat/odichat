class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :parse_whatsapp_message, only: :create

  def index
    mode =      params["hub.mode"]
    token =     params["hub.verify_token"]
    challenge = params["hub.challenge"]

    if mode == "subscribe" && token == Rails.application.credentials.dig(:whatsapp, :webhook_verify_token)
      render json: challenge, status: :ok
    else
      render json: { error: "Invalid verification token" }, status: :unauthorized
    end
  end

  def create
    HandleInboundMessageJob.perform_later(@message_data)
    head :ok
  end

  private

  def parse_whatsapp_message
    parser = WhatsappMessageParser.new(params.permit!.to_h)
    @message_data = parser.extract_message_data

    if @message_data
      Rails.logger.info("✅ Successfully parsed message: #{@message_data}")
    else
      Rails.logger.error("❌ No message found in payload")
      head :ok  # Acknowledge webhook but don't process further
    end
  end
end
