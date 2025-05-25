class Message < ApplicationRecord
  belongs_to :chat

  validates :content, presence: true

  def source
    self.chat.source
  end
end
