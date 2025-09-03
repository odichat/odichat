class Chat < ApplicationRecord
  include OpenaiClient

  belongs_to :chatbot
  belongs_to :inbox
  belongs_to :contact_inbox, optional: true
  belongs_to :contact, optional: true
  belongs_to :conversation, optional: true

  has_many :messages, dependent: :destroy

  validates :source, presence: true
  validates :inbox_id, presence: true

  def whatsapp_channel?
    inbox&.whatsapp_channel?
  end

  def playground_channel?
    inbox&.playground_channel?
  end

  def public_playground_channel?
    inbox&.public_playground_channel?
  end
end
