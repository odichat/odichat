class DeleteVectorStoreJob < ApplicationJob
  queue_as :default

  def perform(vector_store_id)
    OpenAiService.delete_vector_store(vector_store_id)
  rescue StandardError => e
    Rails.logger.error("Error deleting vector store: #{e.message}")
    raise "Error deleting vector store: #{e.message}"
  end
end
