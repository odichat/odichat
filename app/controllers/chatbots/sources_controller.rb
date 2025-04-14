class Chatbots::SourcesController < Chatbots::BaseController
  def show
    @documents = @chatbot.documents.map do |document|
      {
        id: document.id,
        filename: document.file.filename.to_s,
        file_id: document.file_id,
        size: document.file.byte_size,
        signed_id: document.file.signed_id
      }
    end
  end

  def update
    respond_to do |format|
      if chatbot_params[:document_files].present?

        signed_blob_ids = chatbot_params[:document_files]
        documents = []

        signed_blob_ids.each do |signed_blob_id|
          blob = ActiveStorage::Blob.find_signed(signed_blob_id)
          document = @chatbot.documents.create!.tap do |document|
            document.file.attach(blob)
          end
          documents << document
        end

        # Enqueue the upload job
        document_ids = documents.pluck(:id)
        UploadDocumentsToOpenAiJob.perform_later(document_ids)

        format.html { redirect_to chatbots_source_path(@chatbot), notice: "Files uploaded successfully. Processing in background..." }
        format.turbo_stream
      else
        format.html { redirect_to chatbots_source_path(@chatbot), alert: "No files uploaded." }
        format.turbo_stream {
          flash.now[:alert] = "No files uploaded."
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        }
      end
    end
  end

  def destroy
    vector_store_id = @chatbot.vector_store.vector_store_id
    document = @chatbot.documents.find(params[:document_id])
    file_id = document.file_id

    respond_to do |format|
      if document.destroy
        Document.enqueue_remove_from_storage_job(vector_store_id, file_id)
        format.html { redirect_to chatbots_source_path(@chatbot), notice: "File was successfully removed." }
        format.turbo_stream {
          flash.now[:notice] = "File was successfully removed."
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        }
        format.json { head :no_content }
      else
        format.html { redirect_to chatbots_source_path(@chatbot), alert: "File was not removed." }
        format.turbo_stream {
          flash.now[:alert] = "File was not removed."
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        }
        format.json { render json: { error: "File was not removed" }, status: :unprocessable_entity }
      end
    end
  end

  private

  def chatbot_params
    params.require(:chatbot).permit(document_files: [])
  end
end
