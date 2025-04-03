class RemoveDocumentFromVectorStoreJob < ApplicationJob
  queue_as :default

  def perform(vector_store_id, file_id)
    Document.remove_from_vector_store(vector_store_id, file_id)
    Document.remove_from_openai_storage(file_id)
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("Document not found: #{e.message}")
    raise "Document not found: #{e.message}"
  rescue StandardError => e
    Rails.logger.error("Error removing document from vector store: #{e.message}")
    raise "Error removing document from vector store: #{e.message}"
  end
end
