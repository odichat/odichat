class Chat < ApplicationRecord
  belongs_to :chatbot

  validates :source, presence: true

  after_create :create_thread

  private

  def create_thread
    return if self.thread_id.present?
    CreateChatThreadJob.perform_later(self.id)
  end
end
