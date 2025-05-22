class ShareableLink < ApplicationRecord
  belongs_to :chatbot
  validates :token, uniqueness: true
end
