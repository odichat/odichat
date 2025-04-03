class Document < ApplicationRecord
  include OpenaiClient

  belongs_to :chatbot
  has_one_attached :file
  validates :file, content_type: [ "application/pdf", "text/plain", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "text/html" ]

  after_destroy -> { RemoveDocumentFromVectorStoreJob.perform_later(self.chatbot.vector_store_id, self.file_id) }

  def self.remove_from_vector_store(vector_store_id, file_id)
    openai_client.vector_store_files.delete(
      vector_store_id: vector_store_id,
      id: file_id
    )
  end

  def self.remove_from_openai_storage(file_id)
    openai_client.files.delete(id: file_id)
  end
end
