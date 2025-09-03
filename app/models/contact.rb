class Contact < ApplicationRecord
  belongs_to :chatbot
  has_one :conversation, dependent: :destroy
  has_many :contact_inboxes, dependent: :destroy
  has_many :inboxes, through: :contact_inboxes
  has_many :chats, through: :contact_inboxes

  validates :phone_number, presence: true, uniqueness: { scope: :chatbot_id, case_sensitive: false }
end
