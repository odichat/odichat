class Chatbots::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chatbot

  private

  def set_chatbot
    @chatbot = Chatbot.find(params[:chatbot_id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to chatbots_path, alert: "Chatbot not found" }
      format.turbo_stream {
        flash.now[:alert] = "Chatbot not found"
        render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
      }
    end
  end
end
