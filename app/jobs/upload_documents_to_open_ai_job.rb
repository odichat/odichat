class UploadDocumentsToOpenAiJob < ApplicationJob
  queue_as :default

  def perform(document_ids)
    documents = Document.where(id: document_ids)
    chatbot = documents.first.chatbot

    documents.each do |document|
      document.with_lock do
        begin
          file_id = upload_file_to_openai(document)
          document.update!(
            file_id: file_id
          )
          update_vector_store(chatbot)
        rescue StandardError => e
          Rails.logger.error("Error uploading document #{document_id} to OpenAI: #{e.message}")
          raise e
        end
      end
    end
  ensure
    documents = chatbot.documents.map do |document|
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
      target: "form",
      partial: "chatbots/sources/form",
      locals: {
        chatbot: chatbot,
        documents: documents
      }
    )
  end

  private

  def upload_file_to_openai(document)
    Tempfile.create([ "document", safe_extension(document) ]) do |temp_file|
      temp_file.binmode
      temp_file.write(document.file.download)
      temp_file.rewind

      OpenAiService.upload_file_to_openai(temp_file.path)
    ensure
      temp_file&.close
      temp_file&.unlink
    end
  end

  def update_vector_store(chatbot)
    all_file_ids = chatbot.documents.where.not(file_id: nil).pluck(:file_id)
    OpenAiService.update_vector_store_files(chatbot.vector_store_id, all_file_ids)
  end

  def safe_extension(document)
    ext = File.extname(document.file.filename.to_s)
    ext.presence || ".tmp"
  end
end
