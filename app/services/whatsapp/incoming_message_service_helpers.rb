module Whatsapp::IncomingMessageServiceHelpers
  def processed_params
    Rails.logger.info("Processed params IncomingMessageBaseService: #{params.inspect}")
    @processed_params ||= params
  end

  def find_message_by_source_id(source_id)
    return unless source_id
    @message = Message.find_by(source_id: source_id)
  end

  def message_type
    @processed_params[:messages].first[:type]
  end

  def unprocessable_message_type?(message_type)
    %w[reaction image unknown audio video document interactive sticker location contacts].include?(message_type)
  end

  def error_webhook_event?(message)
    message.key?("errors")
  end

  def log_error(message)
    Rails.logger.warn "Whatsapp Error: #{message["errors"][0]["title"]} - contact: #{message["from"]}"
  end

  def message_content(message)
    message.dig(:text, :body)
  end

  def handle_unprocessable_message
    fallback_text = fallback_text_for(message_type)

    Whatsapp::SendMessageService.new(access_token: @waba.access_token).send_message(
      sender_id: @waba.phone_number_id,
      recipient_number: contact_phone_number,
      message: fallback_text
    )
  end

  def contact_phone_number
    @processed_params[:messages].first[:from]
  end

  def contact_name
    @processed_params[:contacts].first[:profile][:name]
  end

  private

  def fallback_text_for(message_type)
    case message_type
    when "location"
      "Lo siento, pero no puedo procesar ubicaciones."
    when "image"
      "Lo siento, pero no puedo ver imágenes — solo puedo procesar texto."
    when "audio"
      "Lo siento, pero no puedo ver audios — solo puedo procesar texto."
    when "video"
      "Lo siento, pero no puedo ver videos — solo puedo procesar texto."
    when "document"
      "Lo siento, pero no puedo ver documentos — solo puedo procesar texto."
    when "interactive"
      "Lo siento, pero no puedo ver interactivos — solo puedo procesar texto."
    when "sticker"
      "Lo siento, pero no puedo ver stickers — solo puedo procesar texto."
    when "reaction"
      "Lo siento, pero no puedo ver reacciones — solo puedo procesar texto."
    when "unknown"
      "Lo siento, pero no puedo ver mensajes desconocidos — solo puedo procesar texto."
    when "contacts"
      "Lo siento, pero no puedo procesar contactos"
    end
  end
end
