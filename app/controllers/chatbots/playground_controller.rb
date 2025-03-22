class Chatbots::PlaygroundController < Chatbots::BaseController
  def edit
    @chat = @chatbot.chats.where(source: "playground").last
    @messages = @chat.messages.order(created_at: :asc) if @chat.present?
  end

  def update
    UpdateAssistantJob.perform_later(@chatbot.id, chatbot_params[:model_id], chatbot_params[:temperature], chatbot_params[:system_instructions])
    respond_to do |format|
      format.html { redirect_to edit_chatbots_playground_path(@chatbot), notice: "Chatbot was successfully updated." }
      format.turbo_stream
    end
  end

  private

  def chatbot_params
    params.require(:chatbot).permit(:name, :model_id, :temperature, :system_instructions)
  end
end
