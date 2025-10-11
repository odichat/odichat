class Message < ApplicationRecord
  include Message::Predicates

  belongs_to :chat
  belongs_to :inbox, optional: true

  validates :content, presence: true
  validates :sender, presence: true, inclusion: { in: %w[ user assistant ] }

  enum :status, { sent: 0, delivered: 1, read: 2, failed: 3 }
  enum :message_type, { auto: 0, manual: 1 }

  # [:external_error : Can specify if the message creation failed due to an error at external API
  store_accessor :content_attributes, :external_error

  scope :automated, ->  { where(sender: "assistant", message_type: :auto) }
  scope :manual,    ->  { where(sender: "assistant", message_type: :manual) }

  delegate :source, :whatsapp_channel?, to: :chat

  after_create_commit :execute_after_create_commit_callbacks
  after_update_commit :execute_after_update_commit_callbacks

  private

  def execute_after_create_commit_callbacks
    # Updates the conversation item status and message preview
    # Appends new message to the selected chat in the chat interface
    broadcast_append_channel_router
    enqueue_post_message_creation_jobs
    update_conversation_record
  end

  def execute_after_update_commit_callbacks
    # Updates the chat list item status and message preview
    if saved_change_to_status?
      chat.conversation.update_from_message(self)
      # broadcast_update_conversation_item
    end
  end

  def broadcast_append_channel_router
    if chat.whatsapp_channel?
      # Broadcast to whatsapp conversation interface
      broadcast_to_conversations_interface
    elsif chat.playground_channel?
      # Broadcast to playground chat interface
      broadcast_to_playground_interface
    elsif chat.public_playground_channel?
      # Broadcast to public playground chat interface
      broadcast_to_public_playground_interface
    end
  end

  def broadcast_to_conversations_interface
    Turbo::StreamsChannel.broadcast_append_to(
      "conversation_contact_#{chat.conversation.id}_messages",
      target: "conversation_#{chat.conversation.id}_messages",
      partial: "messages/message",
      locals: { message: self }
    )
  end

  def broadcast_to_playground_interface
    Turbo::StreamsChannel.broadcast_append_to(
      "playground_chat_#{chat.id}_messages",
      target: "messages",
      partial: "messages/message",
      locals: { message: self }
    )
  end

  def broadcast_to_public_playground_interface
    Turbo::StreamsChannel.broadcast_append_to(
      "public_playground_chat_#{chat.id}_messages",
      target: "messages",
      partial: "public/messages/message",
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
    return if chat&.conversation&.intervention_enabled?
    if Flipper.enabled?(:v2, chat.chatbot.user)
      Conversation::ResponseBuilderJob.perform_later(id)
    else
      Llm::AssistantResponseJob.perform_later(id)
    end
  end

  def update_conversation_record
    return unless chat.conversation.present?
    chat.conversation.update_from_message(self)
  end
end
