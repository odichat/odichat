module Whatsapp::IncomingMessageServiceHelpers
  def processed_params
    Rails.logger.info("Processed params IncomingMessageBaseService: #{params.inspect}")
    @processed_params ||= params
  end

  def process_statuses
    Rails.logger.info("Processing statuses: #{processed_params.inspect}")
  end

  def message_type
    @processed_params[:messages].first[:type]
  end

  def unprocessable_message_type?(message_type)
    %w[reaction image unknown audio video document interactive].include?(message_type)
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
end
