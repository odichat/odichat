class VectorStore < ApplicationRecord
  include OpenaiClient

  belongs_to :chatbot

  after_create :enqueue_create_vector_store_job

  def create_vector_store
    vector_store = openai_client.vector_stores.create(
      parameters: {
        name: self.name,
        file_ids: []
      }
    )

    vector_store_id = vector_store["id"]

    self.update!(vector_store_id: vector_store_id)
  rescue OpenAI::Error => e
    Rails.logger.error("OpenAI::Error creating vector store: #{e.message}")
    raise OpenAI::Error, "Could not create vector store: #{e.message}"
  end

  private

  def enqueue_create_vector_store_job
    CreateVectorStoreJob.perform_later(self.id)
  end
end
