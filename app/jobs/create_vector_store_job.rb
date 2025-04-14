class CreateVectorStoreJob < ApplicationJob
  queue_as :default

  retry_on OpenAI::Error, wait: :polynomially_longer, attempts: 5, priority: :high

  def perform(vector_store_id)
    vector_store = VectorStore.find(vector_store_id)
    vector_store.create_vector_store
  rescue StandardError => e
    Rails.logger.error("Error creating vector store: #{e.message}")
    raise
  end
end
