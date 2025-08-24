class Contact < ApplicationRecord
  belongs_to :chatbot
  has_many :contact_inboxes, dependent: :destroy
  has_many :inboxes, through: :contact_inboxes
  has_many :chats, through: :contact_inboxes
end
