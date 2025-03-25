class WhatsappService
  def self.send_message(wa_phone_number_id, recipient_phone_number, message)
    # client = WhatsappSdk::Api::Messages.new
    wa_integration = WaIntegration.find_by(phone_number_id: wa_phone_number_id)
    client = WhatsappSdk::Api::Client.new(wa_integration.access_token)
    client.send_text(
      sender_id: wa_phone_number_id.to_i,
      recipient_number: recipient_phone_number.to_i,
      message: message
    )
  rescue StandardError => e
    Rails.logger.error("Failed to send WhatsApp message: #{e.message}")
    raise "Failed to send WhatsApp message: #{e.message}"
  end
end
