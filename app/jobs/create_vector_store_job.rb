class CreateVectorStoreJob < ApplicationJob
  queue_as :default

  retry_on OpenAI::Error, wait: :polynomially_longer, attempts: 5, priority: :high

  def perform(vector_store_id)
    vector_store = VectorStore.find_by(id: vector_store_id)

    # If the VectorStore record doesn't exist, it likely means the associated
    # chatbot was deleted. No need to create the vector store in OpenAI.
    unless vector_store
      Rails.logger.info("VectorStore with ID #{vector_store_id} not found. Skipping vector store creation.")
      return
    end

    # If vector_store_id is already set, the vector store was already created
    if vector_store.vector_store_id.present?
      Rails.logger.info("VectorStore #{vector_store_id} already has OpenAI vector_store_id. Skipping creation.")
      return
    end

    vector_store.create_vector_store
  rescue StandardError => e
    Rails.logger.error("Error creating vector store: #{e.message}")
    raise
  end
end
