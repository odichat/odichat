class Chat < ApplicationRecord
  belongs_to :chatbot
  has_many :messages, dependent: :destroy

  validates :source, presence: true

  after_create :create_thread

  def assistant_id
    self.chatbot.assistant_id
  end

  private

  def create_thread
    return if self.thread_id.present?
    CreateThreadJob.perform_later(self.id)
  end
end
