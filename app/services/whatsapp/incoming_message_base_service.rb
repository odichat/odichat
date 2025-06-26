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
    set_waba
    return unless @waba
    return handle_unprocessable_message if unprocessable_message_type?(message_type)

    find_or_create_contact
    find_or_create_chat
    create_messages
  end

  def set_waba
    @waba = ::Waba.includes(:chatbot).find_by(phone_number_id: @processed_params[:metadata][:phone_number_id])
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "Waba not found for BUSINESS PHONE NUMBER ID: #{@processed_params[:metadata][:phone_number_id]}"
  end

  def find_or_create_chat
    @chat = @contact.chat || @contact.create_chat(
      chatbot: @waba.chatbot,
      source: "whatsapp"
    )
  end

  def find_or_create_contact
    @contact = @waba.chatbot.contacts.find_by(phone_number: contact_phone_number)
    if @contact.present?
      # Update contact name if it's not set
      if @contact.name.blank? && contact_name.present?
        @contact.update(name: contact_name)
      end
    else
      # Create contact if it doesn't exist
      @contact = @waba.chatbot.contacts.create!(phone_number: contact_phone_number, name: contact_name)
    end
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
      content: message_content(message)
    )
  end
end
