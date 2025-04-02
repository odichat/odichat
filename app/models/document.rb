class Document < ApplicationRecord
  belongs_to :chatbot

  has_one_attached :file
end
