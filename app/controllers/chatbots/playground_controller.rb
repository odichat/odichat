class Chatbots::PlaygroundController < Chatbots::BaseController
  def show
    @chat = @chatbot.chats.where(source: "playground").last
    @messages = @chat.messages.order(created_at: :asc)
  end

  def update
    if @chatbot.update(chatbot_params)
      respond_to do |format|
        format.html { redirect_to chatbot_playground_path(@chatbot), notice: "Agent was successfully updated." }
        format.turbo_stream {
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages", locals: { flash: { notice: "Agent was successfully updated." } })
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to chatbot_playground_path(@chatbot), alert: "Agent was not updated." }
        format.turbo_stream {
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages", locals: { flash: { alert: @chatbot.errors.full_messages.join(", ") } })
        }
      end
    end
  end

  private

  def chatbot_params
    params.require(:chatbot).permit(:name, :model_id, :temperature, :system_instructions)
  end
end
