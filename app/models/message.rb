class Message < ApplicationRecord
  belongs_to :chat

  validates :content, presence: true

  after_create_commit :execute_after_create_commit_callbacks

  def source
    self.chat.source
  end

  private

  def execute_after_create_commit_callbacks
    send_reply
  end

  def send_reply
    return unless sender == "user"
    GenerateAssistantResponseJob.perform_later(id)
  end
end
