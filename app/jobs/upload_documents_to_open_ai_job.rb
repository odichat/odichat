class UploadDocumentsToOpenAiJob < ApplicationJob
  queue_as :default

  def perform(document_ids)
    documents = Document.includes(file_attachment: :blob).where(id: document_ids)
    return if documents.empty?

    documents.group_by(&:chatbot).each_value do |documents_for_chatbot|
      chatbot = documents_for_chatbot.first.chatbot
      successful_uploads = []
      failed_uploads = []

      documents_for_chatbot.each do |document|
        next if document.file_id.present?
        document.with_lock do
          file_id = process_document_upload(document)
          if file_id.present?
            document.update!(file_id: file_id)
            successful_uploads << file_id
          else
            failed_uploads << document.id
          end
        end
      end

      update_vector_store(chatbot)

      if failed_uploads.empty?
        flash_message = { notice: "Documents uploaded successfully." }
      else
        docs = Document.where(id: failed_uploads)
        flash_message = { alert: "Some documents failed to upload: #{docs.map(&:file).map(&:filename).join(", ")}." }
      end
      notify_ui_of_status(chatbot, flash_message)
    end
  rescue => e
    Rails.logger.error("UploadDocumentsToOpenAIJob error (job_id=#{job_id}): #{e.class}: #{e.message}")
    # Attempt to notify all related chatbots for these documents, if any
    related_chatbots = Document.where(id: document_ids).includes(:chatbot).map(&:chatbot).uniq.compact
    related_chatbots.each do |cb|
      notify_ui_of_status(cb, { alert: "An unexpected error occurred during document upload. Please try again." })
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
      [:sources, chatbot],
      target: "sources-form",
      partial: "chatbots/sources/form",
      locals: {
        chatbot: chatbot,
        documents: documents_for_ui
      }
    )
    Turbo::StreamsChannel.broadcast_replace_to(
      [:sources, chatbot],
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
