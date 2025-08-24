class WhatsappController < ApplicationController
  # So that it's easier to test in development with tools like Postman or curl
  before_action :authenticate_user!, if: -> { Rails.env.production? }
  skip_before_action :verify_authenticity_token, if: -> { Rails.env.development? }
  before_action :set_chatbot, only: [ :create, :exchange_token_and_subscribe_app ]

  def create
    whatsapp_channel = @chatbot.whatsapp_channels.first_or_create!(
      phone_number_id: whatsapp_params[:phone_number_id],
      business_account_id: whatsapp_params[:waba_id]
    )

    @chatbot.inboxes.find_or_create_by!(channel: whatsapp_channel)

    respond_to do |format|
      format.json { render json: { success: true } }
    end
  rescue StandardError => e
    respond_to do |format|
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
    end
  end

  def exchange_token_and_subscribe_app
    ExchangeTokenAndSubscribeAppJob.perform_later(whatsapp_params[:chatbot_id], whatsapp_params[:code])

    respond_to do |format|
      format.turbo_stream
      format.json { render json: { success: true } }
    end
  rescue StandardError => e
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("whatsapp-connection-loader", "") }
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
    end
  end

  private

  def set_chatbot
    chatbot_id = params[:chatbot_id] || whatsapp_params[:chatbot_id]
    @chatbot = Chatbot.find(chatbot_id)
  end

  def whatsapp_params
    params.require(:whatsapp).permit(:chatbot_id, :phone_number_id, :waba_id, :code)
  end
end
