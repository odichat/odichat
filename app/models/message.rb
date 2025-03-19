class Message < ApplicationRecord
  belongs_to :chat

  def source
    self.chat.source
  end
end
