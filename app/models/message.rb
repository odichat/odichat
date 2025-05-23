class Message < ApplicationRecord
  belongs_to :chat

  validates :content, presence: true

  after_create_commit :broadcast_public_user_message

  def source
    self.chat.source
  end

  private

  def broadcast_public_user_message
    return if self.chat.source != "public_playground" || self.sender != "user"
    broadcast_append_to(
      "public_chat_#{self.chat.id}_messages",
      target: "messages",
      partial: "public/messages/message",
      locals: { message: self }
    )
  end
end
