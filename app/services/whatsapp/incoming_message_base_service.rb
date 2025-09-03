class Whatsapp::IncomingMessageBaseService
  include Whatsapp::IncomingMessageServiceHelpers

  attr_reader :params

  def initialize(params:)
    @params = params
  end

  def perform
    processed_params

    if processed_params.try(:[], :statuses).present?
      process_statuses
    elsif processed_params.try(:[], :messages).present?
      process_messages
    end
  end

  private

  def process_messages
    set_whatsapp_channel
    return unless @whatsapp_channel
    return handle_unprocessable_message if unprocessable_message_type?(message_type)

    find_or_create_contact
    find_or_create_contact_inbox
    find_or_create_conversation
    find_or_create_chat
    create_messages
  end

  def process_statuses
    return unless find_message_by_source_id(@processed_params[:statuses].first[:id])
    update_message_with_status(@message, @processed_params[:statuses].first)
  end

  def update_message_with_status(message, status)
    message.status = Message.statuses[status[:status].to_sym]
    if status[:status] == "failed" && status[:errors].present?
      error = status[:errors]&.first
      message.external_error = "#{error[:code]}: #{error[:title]}"
    end
    message.save!
  end

  def set_whatsapp_channel
    @whatsapp_channel = Channel::Whatsapp.find_by(phone_number_id: @processed_params[:metadata][:phone_number_id])
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "Whatsapp channel not found for business_account_id: #{@processed_params[:metadata][:phone_number_id]}"
  end

  def find_or_create_conversation
    @conversation = @contact.conversation || @contact.create_conversation!(chatbot: @whatsapp_channel.chatbot)
  end

  def find_or_create_chat
    most_recent_active_chat = @contact_inbox
      .chats
      .joins(:messages)
      .group("chats.id")
      .select("chats.id, MAX(messages.created_at) as last_message_at")
      .order("last_message_at DESC")
      .limit(1)
      .first

    if most_recent_active_chat.present? && (most_recent_active_chat.last_message_at > 24.hours.ago)
      @chat = @contact_inbox.chats.last
    else
      @chat = @conversation.chats.create!(
        chatbot: @whatsapp_channel.chatbot,
        inbox: @whatsapp_channel.inbox,
        contact_inbox: @contact_inbox,
        contact: @contact,
        source: "whatsapp"
      )
    end
  end

  def find_or_create_contact
    @contact = @whatsapp_channel.chatbot.contacts.find_by(phone_number: contact_phone_number)

    if @contact.present?
      # Update contact name if it's not set
      if @contact.name.blank? && contact_name.present?
        @contact.update(name: contact_name)
      end
    else
      # Create contact if it doesn't exist
      @contact = @whatsapp_channel.chatbot.contacts.create!(phone_number: contact_phone_number, name: contact_name)
    end
  end

  def find_or_create_contact_inbox
    @contact_inbox = @contact.contact_inboxes.find_by(inbox: @whatsapp_channel.inbox, source_id: contact_source_id)
    return if @contact_inbox.present?

    @contact_inbox = @contact.contact_inboxes.create!(inbox: @whatsapp_channel.inbox, source_id: contact_source_id)
  end

  def create_messages
    message = @processed_params[:messages].first
    log_error(message) && return if error_webhook_event?(message)

    create_regular_message(message)
  end

  def create_regular_message(message)
    create_message(message)
    @message.save!
  end

  def create_message(message)
    @message = @chat.messages.build(
      sender: "user",
      message_type: nil, # Only AI generated messages have a type [auto, manual]
      content: message_content(message),
      inbox: @whatsapp_channel.inbox
    )
  end
end
