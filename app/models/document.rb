class Document < ApplicationRecord
  belongs_to :chatbot

  has_one_attached :file

  validates :file, content_type: [ "application/pdf", "text/plain", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "text/html" ]
end
