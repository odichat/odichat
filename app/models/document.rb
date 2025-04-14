class Document < ApplicationRecord
  include OpenaiClient

  belongs_to :chatbot
  has_one_attached :file
  validates :file, content_type: [ "application/pdf", "text/plain", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "text/html" ]

  def upload_file(file_path, purpose = "user_data")
    response = openai_client.files.upload(parameters: { file: file_path, purpose: purpose })
    response["id"]
  end

  class << self
    def enqueue_remove_from_storage_job(vector_store_id, file_id)
      RemoveDocumentFromOpenaiJob.perform_later(vector_store_id, file_id)
    end

    def remove_from_storage(vector_store_id, file_id)
      openai_client = OpenAI::Client.new
      openai_client.vector_store_files.delete(
        vector_store_id: vector_store_id,
        id: file_id
      )
      openai_client.files.delete(id: file_id)
    rescue OpenAI::Error => e
      Rails.logger.error("Error removing document from OpenAI: #{e.message}")
      raise OpenAI::Error, "Error removing document from OpenAI: #{e.message}"
    end
  end
end
