class Chat < ApplicationRecord
  include OpenaiClient

  belongs_to :chatbot
  has_many :messages, dependent: :destroy

  validates :source, presence: true

  def create_thread!
    thread = openai_client.threads.create
    self.update!(thread_id: thread["id"])
  rescue OpenAI::Error => e
    Rails.logger.error("OpenAI error creating thread: #{e.message}")
    raise OpenAI::Error, "OpenAI error creating thread: #{e.message}"
  end

  def assistant_id
    self.chatbot.assistant_id
  end
end
