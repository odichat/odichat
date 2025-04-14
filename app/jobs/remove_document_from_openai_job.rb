class RemoveDocumentFromOpenaiJob < ApplicationJob
  queue_as :default
  retry_on OpenAI::Error, wait: :polynomially_longer, attempts: 5

  def perform(vector_store_id, file_id)
    Document.remove_from_storage(vector_store_id, file_id)
  rescue StandardError => e
    Rails.logger.error("Error removing document from OpenAI: #{e.message}")
    raise
  end
end
