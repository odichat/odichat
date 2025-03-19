class Message < ApplicationRecord
  belongs_to :chat

  validates :content, presence: true

  after_create :generate_assistant_response

  def source
    self.chat.source
  end

  private

  def generate_assistant_response
    GenerateAssistantResponseJob.perform_later(self.id) if self.sender == "user"
  end
end
