class Chat < ApplicationRecord
  belongs_to :chatbot
  has_many :messages, dependent: :destroy

  validates :source, presence: true

  def assistant_id
    self.chatbot.assistant_id
  end
end
