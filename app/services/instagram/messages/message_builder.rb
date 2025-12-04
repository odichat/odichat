class Instagram::Messages::MessageBuilder
  attr_reader :messaging

  def initialize(messaging, inbox, outgoing_echo: false)
    @messaging = messaging
    @inbox = inbox
    @outgoing_echo = outgoing_echo
  end

  def perform
    # TODO:
    # The auth tokens obtained on users behalf could expire and/or become invalid.
    # For example, when the user changes their password, the auth token stored in the database could become invalid.
    # return if @inbox.channel.reauthorization_required?

    ActiveRecord::Base.transaction do
      build_message
    end
  rescue StandardError => e
    handle_error(e)
  end

  private

  def build_message
    # Duplicate webhook events may be sent for the same message
    # when a user is connected to the Instagram account through both Messenger and Instagram login.
    # There is chance for echo events to be sent for the same message.
    # Therefore, we need to check if the message already exists before creating it.
    return if associate_outgoing_echo_with_existing_message
    return if message_already_exists?

    return if message_content.blank? && all_unsupported_files?

    @message ||= chat.messages.create!(message_params)
    # save_story_id

    # attachments.each do |attachment|
    #   process_attachment(attachment)
    # end
  end

  def message_already_exists?
    find_message_by_source_id(@messaging[:message][:mid]).present?
  end

  def find_message_by_source_id(source_id)
    return unless source_id

    @message = Message.find_by(source_id: source_id)
  end

  def message_params
    {
      inbox: @inbox,
      sender: @outgoing_echo ? "assistant" : "user",
      message_type: nil,
      content: message_content,
      source_id: message_identifier
    }
  end

  def conversation
    # @conversation ||= set_conversation_based_on_inbox_config
    @conversation ||= find_or_create_conversation
  end

  def find_or_create_conversation
    contact.conversation || build_conversation
  end

  def chat
    @chat ||= find_or_create_chat
  end

  def find_or_create_chat
    recent_chat = contact_inbox.chats.order(created_at: :desc).first
    return recent_chat if recent_chat&.created_at&.> 24.hours.ago

    conversation.chats.create!(
      chatbot: conversation.chatbot,
      inbox: @inbox,
      contact_inbox: contact_inbox,
      contact: contact,
      source: "instagram"
    )
  end

  def build_conversation
    Conversation.create!(
      contact: contact,
      chatbot: contact.chatbot
    )
  end

  def message_content
    @messaging[:message][:text]
  end

  def contact
    @contact ||= contact_inbox.contact
  end

  def contact_inbox
    @contact_inbox ||= @inbox.contact_inboxes.find_by!(source_id: message_source_id)
  end

  def message_source_id
    @outgoing_echo ? recipient_id : sender_id
  end

  def message_type
    @outgoing_echo ? :outgoing : :incoming
  end

  def message_identifier
    message[:mid]
  end

  def message
    @messaging[:message]
  end

  def sender_id
    @messaging[:sender][:id]
  end

  def recipient_id
    @messaging[:recipient][:id]
  end

  def attachments
    @messaging[:message][:attachments] || {}
  end

  def handle_error(error)
    # ChatwootExceptionTracker.new(error, account: @inbox.account).capture_exception
    Rails.logger.warn("Base message builder failed: #{error}")
    Rails.logger.warn("Base message builder failed: #{error}")
  end

  def associate_outgoing_echo_with_existing_message
    return false unless @outgoing_echo

    message_to_update = find_echo_candidate_message
    return false unless message_to_update

    message_to_update.update!(source_id: message_identifier)
    true
  end

  def find_echo_candidate_message
    return unless conversation

    chat_ids = conversation.chats.select(:id)
    scope = Message.where(chat_id: chat_ids, sender: "assistant", source_id: nil)
    scope = scope.where(content: message_content) if message_content.present?
    scope.order(created_at: :desc).first
  end

  def all_unsupported_files?
    return if attachments.empty?

    attachments_type = attachments.pluck(:type).uniq.first
    unsupported_file_type?(attachments_type)
  end

  def unsupported_file_type?(attachment_type)
    [ :template, :audio, :image, :video, :reaction, :sticker, :unsupported_type ].include? attachment_type.to_sym
  end
end
