class ContactInbox < ApplicationRecord
  belongs_to :contact
  belongs_to :inbox
  has_many :chats, dependent: :destroy

  validates :source_id, presence: true, uniqueness: { scope: :inbox_id, case_sensitive: false }
end
