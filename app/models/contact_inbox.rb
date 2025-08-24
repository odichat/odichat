class ContactInbox < ApplicationRecord
  belongs_to :contact
  belongs_to :inbox
  has_many :chats, dependent: :destroy

  validates :source_id, presence: true
end
