class Document < ApplicationRecord
  include OpenaiClient

  belongs_to :chatbot
  has_one_attached :file
  validates :file, content_type: [ "application/pdf", "text/plain", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "text/html" ]

  class << self
    def remove_from_openai(vector_store_id, file_id)
      RemoveDocumentFromOpenaiJob.perform_later(vector_store_id, file_id)
    end
  end
end
