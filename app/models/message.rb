class Message < ApplicationRecord
  belongs_to :chat

  validates :content, presence: true

  after_create_commit :execute_after_create_commit_callbacks

  def source
    self.chat.source
  end

  def assistant?
    sender == "assistant"
  end

  def user?
    sender == "user"
  end

  private

  def execute_after_create_commit_callbacks
    enqueue_post_message_creation_jobs
  end

  def enqueue_post_message_creation_jobs
    enqueue_assistant_response_generation_job if user?
    enqueue_send_reply_job if assistant?
  end

  def enqueue_send_reply_job
    SendReplyJob.perform_later(id)
  end

  def enqueue_assistant_response_generation_job
    Llm::AssistantResponseJob.perform_later(id)
  end
end
