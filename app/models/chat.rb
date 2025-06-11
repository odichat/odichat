class Chat < ApplicationRecord
  include OpenaiClient

  belongs_to :chatbot

  has_many :messages, dependent: :destroy

  validates :source, presence: true

  def whatsapp_channel?
    source == "whatsapp"
  end

  def playground_channel?
    source == "playground"
  end

  def public_playground_channel?
    source == "public_playground"
  end
end
