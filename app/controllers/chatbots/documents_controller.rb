class Chatbots::DocumentsController < Chatbots::BaseController
  def index
  end

  def create
    document_attributes = document_params

    @document = @chatbot.documents.build(document_attributes)

    if @document.save
      respond_to do |format|
        format.html { redirect_to chatbot_responses_path(@chatbot), notice: "#{@document.file.blob.filename} is being processed..." }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              "pdf_modal",
              partial: "chatbots/responses/pdf_upload_modal",
              locals: { chatbot: @chatbot }
            ),
            turbo_stream.replace(
              ActionView::RecordIdentifier.dom_id(@chatbot, :responses_list),
              partial: "chatbots/responses/responses_list",
              locals: {
                chatbot: @chatbot,
                responses: [],
                pagy: nil,
                is_processing_documents: @chatbot.documents.pending.any?
              }
            )
          ]
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to chatbot_responses_path(@chatbot), alert: "Error uploading document. Try again." }
      end
    end
  end

  private

    def document_params
      params.require(:document).permit(:file)
    end
end
