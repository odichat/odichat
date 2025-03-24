class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :parse_whatsapp_message, only: :create
  before_action :set_wa_integration, only: :create

  def index
    mode =      params["hub.mode"]
    token =     params["hub.verify_token"]
    challenge = params["hub.challenge"]

    if mode == "subscribe" && token == ENV["WEBHOOK_VERIFY_TOKEN"]
      render json: challenge, status: :ok
    else
      render json: { error: "Invalid verification token" }, status: :unauthorized
    end
  end


  def create
    wa_phone_number_id = @wa_integration.phone_number_id

    if wa_phone_number_id.present?
      WhatsappService.send_message(wa_phone_number_id, @message_data[:from_phone_number], "PONG!")
      head :ok
    else
      render json: { error: "WA phone number ID not found" }, status: :unprocessable_entity
    end
  end

  private

  def parse_whatsapp_message
    parser = WhatsappMessageParser.new(params.permit!.to_h)
    Rails.logger.info("⚡️ Incoming WhatsApp webhook payload: #{params.permit!.to_h}")

    @message_data = parser.extract_message_data
    puts "PUTS: @message_data: #{@message_data}"
    Rails.logger.info("PUTS: @message_data: #{@message_data}")

    if @message_data
      puts "PUTS: ✅ Successfully parsed message: #{@message_data}"
      Rails.logger.info("✅ Successfully parsed message: #{@message_data}")
    else
      Rails.logger.error("❌ No message found in payload")
      puts "PUTS: ❌ No message found in payload"
      head :ok  # Acknowledge webhook but don't process further
    end
  end

  def set_wa_integration
    @wa_integration = WaIntegration.find_by!(waba_id: @message_data[:waba_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Waba ID not found" }, status: :unprocessable_entity
  end
end
