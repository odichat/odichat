class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :parse_whatsapp_message, only: :create

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
    return head :unprocessable_entity unless @message_data

    if @message_data[:message_text].present?
      WhatsappService.send_message(@message_data[:phone], "PONG!")
    end
  end

  private

  def parse_whatsapp_message
    parser = WhatsappMessageParser.new(params.permit!.to_h)
    @message_data = parser.extract_message_data
  end
end
