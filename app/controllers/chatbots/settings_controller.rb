class Chatbots::SettingsController < Chatbots::BaseController
  def show
  end

  def update
    if @chatbot.update(chatbot_params)
      respond_to do |format|
        format.html { redirect_to chatbot_settings_path, notice: "Chatbot was successfully updated." }
        format.turbo_stream {
          flash.now[:notice] = "Chatbot was successfully updated."
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to chatbot_settings_path, alert: @chatbot.errors.full_messages.to_sentence }
        format.turbo_stream {
          flash.now[:alert] = @chatbot.errors.full_messages.to_sentence
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        }
      end
    end
  end

  def destroy
    if @chatbot.destroy
      respond_to do |format|
        format.html { redirect_to chatbots_path, info: "Agent was successfully deleted." }
      end
    else
      respond_to do |format|
        format.html { redirect_to chatbots_path, alert: "This agent cannot be deleted at this moment." }
      end
    end
  end

  private

  def chatbot_params
    params.require(:chatbot).permit(:name)
  end
end
