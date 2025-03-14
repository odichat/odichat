class Chatbots::SettingsController < Chatbots::BaseController
  before_action :set_chatbot

  def show
  end

  def update
    if @chatbot.update(chatbot_params)
      respond_to do |format|
        format.html { redirect_to chatbots_setting_path, notice: "Chatbot was successfully updated." }
        format.turbo_stream {
          flash.now[:notice] = "Chatbot was successfully updated."
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to chatbots_setting_path, alert: @chatbot.errors.full_messages.to_sentence }
        format.turbo_stream {
          flash.now[:alert] = @chatbot.errors.full_messages.to_sentence
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_chatbot
    @chatbot = Chatbot.find(params[:id])
  end

  def chatbot_params
    params.require(:chatbot).permit(:name)
  end
end
