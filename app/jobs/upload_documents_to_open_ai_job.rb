# frozen_string_literal: true

class UploadDocumentsToOpenAiJob < ApplicationJob
  queue_as :default

  def perform(document_ids)
    documents = Document.where(id: document_ids, status: :pending)
    return if documents.empty?

    documents.group_by(&:chatbot).each do |chatbot, docs_for_chatbot|
      process_documents_for_chatbot(chatbot, docs_for_chatbot)
    end
  rescue StandardError => e
    # Broad rescue for unexpected errors (e.g., database connection issues)
    Rails.logger.error("UploadDocumentsToOpenAiJob failed for document_ids #{document_ids}: #{e.message}")
    # Notify all related chatbots of a systemic failure
    Document.where(id: document_ids).includes(:chatbot).map(&:chatbot).uniq.compact.each do |cb|
      notify_ui(cb, { alert: "An unexpected error occurred during processing. Please try again." })
    end
  end

  private

  # AIDEV-NOTE: This is the main orchestration method for a single chatbot's documents.
  # It ensures that files are uploaded first, then attached to the vector store.
  def process_documents_for_chatbot(chatbot, documents)
    documents.each do |document|
      document.with_lock do
        handle_upload(document) unless document.file_id.present?
      end
    end

    # Refresh documents from DB to get the latest state after uploads
    chatbot.reload
    attachable_docs = chatbot.documents.where(id: documents.map(&:id)).where.not(status: :failed)
    file_ids_to_attach = attachable_docs.pluck(:file_id).compact

    if file_ids_to_attach.any?
      handle_vector_store_update(chatbot, attachable_docs, file_ids_to_attach)
    end

    # Final UI notification based on terminal states
    notify_final_status(chatbot, documents)
  end

  # AIDEV-NOTE: Handles the individual file upload to OpenAI.
  # It's idempotent; if a file_id already exists, this step is skipped.
  # On failure, it marks the document as 'failed' and stops its workflow.
  def handle_upload(document)
    temp_file = Tempfile.new(["document", safe_extension(document)])
    temp_file.binmode
    temp_file.write(document.file.download)
    temp_file.rewind

    file_id = document.upload_file(temp_file.path)
    document.update!(file_id: file_id)
  rescue StandardError => e
    document.update!(status: :failed)
    Rails.logger.error("Failed to upload document #{document.id} to OpenAI: #{e.message}")
  ensure
    temp_file&.close
    temp_file&.unlink
  end

  # AIDEV-NOTE: Attaches all valid file_ids to the vector store in a single batch.
  # If this API call fails, all documents that are not already 'uploaded' are marked as 'failed'.
  def handle_vector_store_update(chatbot, documents, file_ids)
    chatbot.vector_store.attach_files(file_ids)
    documents.each { |doc| doc.update!(status: :uploaded) }
  rescue StandardError => e
    Rails.logger.error("Failed to attach files to vector store for chatbot #{chatbot.id}: #{e.message}")
    # Mark all documents that weren't already successfully uploaded as failed
    documents.where.not(status: :uploaded).update_all(status: :failed)
  end

  # AIDEV-NOTE: Notifies the UI about the final status of the batch operation.
  # It checks for any failures to provide a more accurate flash message.
  def notify_final_status(chatbot, documents)
    chatbot.reload
    failed_docs = chatbot.documents.where(id: documents.map(&:id), status: :failed)

    flash_message = if failed_docs.any?
      { alert: "Some documents failed to process: #{failed_docs.map { |d| d.file.filename }.join(", ")}." }
    else
      { notice: "Documents processed successfully." }
    end

    notify_ui(chatbot, flash_message)
  end

  # AIDEV-NOTE: Broadcasts updates to the UI via Turbo Streams.
  # This keeps the user informed of the outcome.
  def notify_ui(chatbot, flash)
    documents_for_ui = chatbot.documents.map do |document|
      {
        id: document.id,
        file_id: document.file_id,
        filename: document.file.filename,
        size: document.file.byte_size,
        signed_id: document.file.signed_id,
        status: document.status
      }
    end

    Turbo::StreamsChannel.broadcast_replace_to(
      [ :sources, chatbot ],
      target: "sources-form",
      partial: "chatbots/sources/form",
      locals: { chatbot: chatbot, documents: documents_for_ui }
    )
    Turbo::StreamsChannel.broadcast_replace_to(
      [ :sources, chatbot ],
      target: "flash",
      partial: "shared/flash_messages",
      locals: { flash: flash }
    )
  end

  def safe_extension(document)
    File.extname(document.file.filename.to_s).presence || ".tmp"
  end
end
