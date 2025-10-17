class Chatbots::DocumentsController < Chatbots::BaseController
  def index
  end

  def create
    document_attributes = document_params
    file = document_attributes[:file]

    if file.blank?
      handle_failed_upload("Select a PDF document to upload.")
      return
    end

    @document = @chatbot.documents.build(document_attributes)

    if @document.save
      handle_successful_upload
    else
      handle_failed_upload(@document.errors.full_messages.to_sentence.presence || "Unable to upload document.")
    end
  rescue ActionController::ParameterMissing
    handle_failed_upload("Select a PDF document to upload.")
  end

  private

  def document_params
    params.require(:document).permit(:file)
  end

  def handle_successful_upload
    notice_message = "'#{@document.file.blob.filename}' is being processed... We’ll drop the FAQs here when they’re ready"

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = notice_message
        processing_documents = @chatbot.documents.pending

        render turbo_stream: [
          turbo_stream.replace(
            "pdf_modal",
            partial: "chatbots/responses/pdf_upload_modal"
          ),
          turbo_stream.replace(
            helpers.dom_id(@chatbot, :processing_placeholder),
            partial: "chatbots/responses/processing_placeholder",
            locals: {
              chatbot: @chatbot,
              processing_documents: processing_documents
            }
          ),
          turbo_stream.update(
            "flash",
            partial: "shared/flash_messages"
          )
        ]
      end
      format.html { redirect_to chatbot_responses_path(@chatbot), notice: notice_message }
    end
  end

  def handle_failed_upload(message)
    respond_to do |format|
      format.turbo_stream do
        flash.now[:alert] = message
        render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages"), status: :unprocessable_entity
      end
      format.html { redirect_to chatbot_responses_path(@chatbot), alert: message }
    end
  end
end
