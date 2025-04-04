class WhatsappService
  def self.send_message(waba_id, recipient_phone_number, message)
    # client = WhatsappSdk::Api::Messages.new
    waba = Waba.find_by(waba_id: waba_id)

    client = WhatsappSdk::Api::Client.new(waba.access_token, "v21.0", Logger.new(STDOUT), { bodies: true })
    client.messages.send_text(
      sender_id: waba.phone_number_id.to_i,
      recipient_number: recipient_phone_number.to_i,
      message: message
    )
  rescue StandardError => e
    Rails.logger.error("Failed to send WhatsApp message: #{e.message}")
    raise "Failed to send WhatsApp message: #{e.message}"
  end
end
