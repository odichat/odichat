class WhatsappService
  def self.send_message(phone_number, message)
    client = WhatsappSdk::Api::Messages.new
    client.send_text(
      sender_id: ENV["WHATSAPP_SENDER_ID"].to_i,
      recipient_number: phone_number.to_i,
      message: message
    )
  rescue StandardError => e
    Rails.logger.error("Failed to send WhatsApp message: #{e.message}")
    raise "Failed to send WhatsApp message: #{e.message}"
  end
end
