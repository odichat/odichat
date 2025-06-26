class Contact < ApplicationRecord
  belongs_to :chatbot
  has_one :chat, dependent: :destroy

  validates :phone_number, presence: true
  validates :phone_number, uniqueness: { scope: :chatbot_id }
end
