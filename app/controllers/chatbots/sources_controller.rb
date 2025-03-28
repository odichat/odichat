class Chatbots::SourcesController < Chatbots::BaseController
  def edit
    @documents = @chatbot.documents.map do |document|
      {
        id: document.id,
        filename: document.filename.to_s,
        size: document.byte_size,
        signed_id: document.signed_id
      }
    end
  end

  def update
    respond_to do |format|
      if @chatbot.update(chatbot_params)
        format.html { redirect_to chatbots_source_path(@chatbot), notice: "Agent was successfully trained." }
        format.turbo_stream {
          flash.now[:notice] = "Agent was successfully trained."
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        }
      else
        format.html { redirect_to chatbots_source_path(@chatbot), alert: @chatbot.errors.full_messages.join(", ") }
        format.turbo_stream {
          flash.now[:alert] = @chatbot.errors.full_messages.join(", ")
        render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
      }
      end
    end
  end

  private

  def chatbot_params
    params.require(:chatbot).permit(documents: [])
  end
end
