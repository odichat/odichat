class Message < ApplicationRecord
  belongs_to :chat

  validates :content, presence: true

  enum :status, { sent: 0, delivered: 1, read: 2, failed: 3 }
  enum :message_type, { auto: 0, manual: 1 }

  # [:external_error : Can specify if the message creation failed due to an error at external API
  store_accessor :content_attributes, :external_error

  scope :automated, -> { where(message_type: :auto) }
  scope :manual, -> { where(message_type: :manual) }

  after_create_commit :execute_after_create_commit_callbacks
  after_update_commit :execute_after_update_commit_callbacks

  def source
    self.chat.source
  end

  def whatsapp?
    chat.whatsapp_channel?
  end

  def assistant?
    sender == "assistant"
  end

  def user?
    sender == "user"
  end

  private

  def execute_after_create_commit_callbacks
    # Updates the chat list item status and message preview
    broadcast_update_chat_interface_chat_list_item
    # Appends new message to the selected chat in the chat interface
    broadcast_append_chat_interface_message_to_chat
    enqueue_post_message_creation_jobs
  end

  def execute_after_update_commit_callbacks
    # Updates the chat list item status and message preview
    broadcast_update_chat_interface_chat_list_item if saved_change_to_status?
  end

  def broadcast_update_chat_interface_chat_list_item
    Turbo::StreamsChannel.broadcast_replace_to(
      "chatbot_#{chat.chatbot.id}_chat_list_container",
      target: "chat_list_item_#{chat.id}",
      partial: "chatbots/chats/chat_interface/side/chat_list_item",
      locals: { chat: chat }
    )
  end

  def broadcast_append_chat_interface_message_to_chat
    Turbo::StreamsChannel.broadcast_append_to(
      "chat_#{chat.id}_messages",
      target: "chat_messages_#{chat.id}",
      partial: "messages/message",
      locals: { message: self }
    )
  end

  def enqueue_post_message_creation_jobs
    enqueue_assistant_response_generation_job if user?
    enqueue_send_reply_job if assistant?
  end

  def enqueue_send_reply_job
    SendReplyJob.perform_later(id)
  end

  def enqueue_assistant_response_generation_job
    return if chat.intervention_enabled?
    Llm::AssistantResponseJob.perform_later(id)
  end
end
