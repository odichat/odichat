class WaIntegrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chatbot, only: [ :create ]

  def create
    @wa_integration = @chatbot.wa_integration || @chatbot.build_wa_integration(wa_integration_params)

    respond_to do |format|
      if @wa_integration.save
        format.json { render json: { success: true } }
      else
        format.json { render json: { error: @wa_integration.errors.full_messages.join(", ") }, status: :unprocessable_entity }
      end
    end
  end

  def exchange_token_and_subscribe_app
    raise "No chatbot_id was provided" if params[:chatbot_id].blank?
    raise "No exchange token was provided" if exchange_token_params[:code].blank?

    ExchangeTokenAndSubscribeAppJob.perform_later(params[:chatbot_id], exchange_token_params[:code])

    respond_to do |format|
      format.json { render json: { success: true } }
    end
  rescue StandardError => e
    respond_to do |format|
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
    end
  end

  private

  def wa_integration_params
    params.require(:wa_integration).permit(:phone_number_id, :waba_id)
  end

  def exchange_token_params
    params.require(:wa_integration).permit(:code)
  end

  def set_chatbot
    @chatbot = Chatbot.find(params[:chatbot_id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.json { render json: { error: "Chatbot not found" }, status: :not_found }
    end
  end
end
