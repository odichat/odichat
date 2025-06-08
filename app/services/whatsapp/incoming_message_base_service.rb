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
    return if unprocessable_message_type?(message_type)

    set_waba
    return unless @waba

    find_chat_or_create_by_contact_phone_number
    create_messages
  end

  def set_waba
    @waba = ::Waba.includes(:chatbot).find_by(phone_number_id: @processed_params[:metadata][:phone_number_id])
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "Waba not found for BUSINESS PHONE NUMBER ID: #{@processed_params[:metadata][:phone_number_id]}"
  end

  def find_chat_or_create_by_contact_phone_number
    @chat = @waba.chatbot.chats.find_or_create_by(
      contact_phone: @processed_params[:messages].first[:from],
      source: "whatsapp"
    )
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
