class UploadDocumentsToOpenAiJob < ApplicationJob
  queue_as :default

  def perform(document_ids)
    documents = Document.where(id: document_ids)
    return if documents.empty?

    chatbot = documents.first.chatbot
    successful_uploads = []
    failed_uploads = []

    begin
      documents.each do |document|
        if process_document_upload(document)
          successful_uploads << document
        else
          failed_uploads << document
        end
      end

      update_vector_store(chatbot)

      if failed_uploads.empty?
        flash_message = { notice: "Documents uploaded successfully." }
      else
        flash_message = { alert: "Some documents failed to upload. Please check the logs for details." }
      end
      notify_ui_of_status(chatbot, flash_message)
    rescue StandardError => e
      Rails.logger.error("Overall error in UploadDocumentsToOpenAiJob for chatbot #{chatbot.id}: #{e.message}")
      notify_ui_of_status(chatbot, { alert: "An unexpected error occurred during document upload. Please try again." })
    end
  end

  private

  def process_document_upload(document)
    document.with_lock do
      temp_file = nil
      begin
        temp_file = Tempfile.new([ "document", safe_extension(document) ])
        temp_file.binmode
        temp_file.write(document.file.download)
        temp_file.rewind

        file_id = document.upload_file(temp_file.path)
        document.update!(file_id: file_id)
        file_id
      rescue Faraday::TooManyRequestsError => e
        Rails.logger.error("OpenAI Rate Limit/Funds Error for document #{document.id}: #{e.message}")
        # TODO: This should send a notification to the admin via email/slack
        nil # Indicate failure
      rescue StandardError => e
        Rails.logger.error("Error uploading document #{document.id} to OpenAI: #{e.message}")
        nil # Indicate failure
      ensure
        temp_file&.close
        temp_file&.unlink
      end
    end
  end

  def update_vector_store(chatbot)
    file_ids = chatbot.documents.where.not(file_id: nil).pluck(:file_id)
    chatbot.vector_store.attach_files(file_ids)
  end

  def notify_ui_of_status(chatbot, flash_message)
    documents_for_ui = chatbot.documents.map do |document|
      {
        id: document.id,
        file_id: document.file_id,
        filename: document.file.filename,
        size: document.file.byte_size,
        signed_id: document.file.signed_id
      }
    end
    Turbo::StreamsChannel.broadcast_replace_to(
      "sources",
      target: "sources-form",
      partial: "chatbots/sources/form",
      locals: {
        chatbot: chatbot,
        documents: documents_for_ui
      }
    )
    Turbo::StreamsChannel.broadcast_replace_to(
      "sources",
      target: "flash",
      partial: "shared/flash_messages",
      locals: {
        flash: flash_message
      }
    )
  end

  def safe_extension(document)
    ext = File.extname(document.file.filename.to_s)
    ext.presence || ".tmp"
  end
end
