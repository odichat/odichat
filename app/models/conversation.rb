class Conversation < ApplicationRecord
  attr_accessor :broadcasting_message

  belongs_to :chatbot
  belongs_to :contact
  has_many :chats, dependent: :destroy

  validates :chatbot_id, :contact_id, presence: true

  scope :ordered_by_latest, -> { order(latest_message_at: :desc) }

  after_update_commit :execute_after_update_callbacks

  # The `latest_message_status` attribute is stored in the database as a string
  # (e.g., "sent", "delivered"). However, in our views, we want to be able to
  # check the status using query methods like `.sent?` or `.delivered?`,
  # similar to how Rails enums work.
  #
  # ActiveSupport::StringInquirer is a special class that wraps a string and
  # allows you to check for equality by calling a method with a question mark.
  # For example, if the status is "sent", `ActiveSupport::StringInquirer.new("sent").sent?`
  # will return true.
  #
  # By overriding the getter method for `latest_message_status` and returning
  # a StringInquirer object, we provide a clean, Rails-idiomatic way to handle
  # status checks in the view without changing the underlying data type in the database
  # or cluttering the view with string comparisons.
  def latest_message_status
    return nil if self[:latest_message_status].blank?

    ActiveSupport::StringInquirer.new(self[:latest_message_status])
  end

  def toggle_intervention!
    if intervention_enabled?
      disable_intervention!
    else
      enable_intervention!
    end
  end

  def enable_intervention!
    update(
      intervention_enabled: true,
    )
  end

  def disable_intervention!
    update(
      intervention_enabled: false,
    )
  end

  # Checks if the WhatsApp 24-hour reply window is open, based on the
  # timestamp of the last message received from the user.
  def whatsapp_reply_window_open?
    latest_incoming_message_at.present? && (latest_incoming_message_at > 24.hours.ago)
  end

  def update_from_message(message)
    self.broadcasting_message = message
    # When a new message is created, we update the conversation attributes
    # with the details of the latest message.
    assign_attributes(
      latest_message_at: message.created_at,
      latest_incoming_message_at: message.user? ? message.created_at : latest_incoming_message_at,
      latest_message_status: message.status,
      latest_message_content: message.content
    )

    save! if changed?
  end

  private

  def execute_after_update_callbacks
    # We broadcast a Turbo Stream to prepend the conversation item
    # When the latest_message_at attribute changes, or latest_message_status
    broadcast_prepend_conversation_item if saved_change_to_latest_message_at?
    broadcast_update_status_check if saved_change_to_latest_message_status?
  end

  def broadcast_prepend_conversation_item
    Turbo::StreamsChannel.broadcast_prepend_to(
      "chatbot_#{chatbot_id}_chat_list_container",
      target: "side_chat_list_container",
      partial: "chatbots/conversations/list/conversation_item",
      locals: { conversation: self }
    )
  end

  def broadcast_update_status_check
    Turbo::StreamsChannel.broadcast_replace_to(
      "chatbot_#{chatbot_id}_chat_list_container",
      target: "conversation_item_#{id}",
      partial: "chatbots/conversations/list/conversation_item",
      locals: { conversation: self }
    )

    return unless broadcasting_message

    is_playground = broadcasting_message.chat.playground_channel? || broadcasting_message.chat.public_playground_channel?
    return if is_playground

    Turbo::StreamsChannel.broadcast_replace_to(
      "conversation_contact_#{id}_messages",
      target: "message_#{broadcasting_message.id}",
      partial: "messages/message",
      locals: { message: broadcasting_message, is_playground: false }
    )
  end
end
