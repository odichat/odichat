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
        rescue Faraday::TooManyRequestsError => e
          # TODO: This should send a notification to the admin via email/slack
          raise "Check your OpenAI account for rate limits or missing funds"
        rescue StandardError => e
          Rails.logger.error("Error uploading document #{document.id} to OpenAI: #{e.message}")
          raise "Error uploading document #{document.id} to OpenAI: #{e.message}"
        end
      end
    end

    update_vector_store(chatbot)

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
      target: "sources-form",
      partial: "chatbots/sources/form",
      locals: {
        chatbot: chatbot,
        documents: documents
      }
    )
    Turbo::StreamsChannel.broadcast_replace_to(
      "sources",
      target: "flash",
      partial: "shared/flash_messages",
      locals: {
        flash: { notice: "Documents uploaded successfully" }
      }
    )
  end

  private

  def upload_file_to_openai(document)
    temp_file = nil
    begin
      temp_file = Tempfile.new([ "document", safe_extension(document) ])
      temp_file.binmode
      temp_file.write(document.file.download)
      temp_file.rewind

      document.upload_file(temp_file.path)
    ensure
      temp_file&.close
      temp_file&.unlink
    end
  end

  def update_vector_store(chatbot)
    file_ids = chatbot.documents.where.not(file_id: nil).pluck(:file_id)
    chatbot.vector_store.attach_files(file_ids)
  end

  def safe_extension(document)
    ext = File.extname(document.file.filename.to_s)
    ext.presence || ".tmp"
  end
end
