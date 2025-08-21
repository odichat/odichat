class Whatsapp::SendMessageService
  def initialize(access_token: nil)
    access_token ||= set_default_access_token
    @client = WhatsappSdk::Api::Client.new(access_token, "v21.0", Logger.new(STDOUT), { bodies: true })
  end

  def send_message(sender_id:, recipient_number:, message:)
    @client.messages.send_text(
      sender_id: sender_id,
      recipient_number: recipient_number,
      message: message
    )
  rescue WhatsappSdk::Api::Responses::HttpResponseError => e
    if e.message.match?(/"code"=>131037/)
      # This error indicates that the display name needs approval
      raise Whatsapp::DisplayNameApprovalError, e.message
    else
      Rails.logger.error("WhatsApp API Error: #{e.message}")
      raise e
    end
  end

  private

  def set_default_access_token
    Rails.application.credentials.dig(:whatsapp, :access_token)
  end
end
