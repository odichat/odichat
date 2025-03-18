class Chatbots::PlaygroundController < Chatbots::BaseController
  def show
    @chat = @chatbot.chats.where(source: "playground").last
  end

  def update
    if @chatbot.update(chatbot_params)
      respond_to do |format|
        format.html { redirect_to chatbots_playground_path(@chatbot), notice: "Settings updated successfully." }
        format.turbo_stream {
          flash.now[:notice] = "Settings updated successfully."
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to chatbots_playground_path(@chatbot), alert: @chatbot.errors.full_messages.to_sentence }
        format.turbo_stream {
          flash.now[:alert] = @chatbot.errors.full_messages.to_sentence
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        }
      end
    end
  end

  private

  def chatbot_params
    params.require(:chatbot).permit(:model_id, :temperature, :system_instructions)
  end
end
