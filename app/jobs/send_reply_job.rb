class SendReplyJob < ApplicationJob
  queue_as :default

  attr_reader :message, :chat, :inbox

  def perform(message_id)
    @message = Message.includes(chat: :contact).find(message_id)
    @chat = message.chat
    @inbox = chat.inbox

    send_message_to_channel
  end

  private

  def send_message_to_channel
    send_message_to_whatsapp if inbox.whatsapp_channel?
    send_message_to_instagram if inbox.instagram_channel?
  end

  def send_message_to_whatsapp
    # In development and test environments, we skip sending messages to WhatsApp
    return unless Rails.env.production?
    response = Whatsapp::SendMessageService.new(access_token: inbox.channel.access_token).send_message(
      sender_id: inbox.channel.phone_number_id.to_i,
      recipient_number: chat.contact.phone_number.to_i,
      message: message.content
    )
    message.update(source_id: response.messages&.first&.id)
  rescue Whatsapp::DisplayNameApprovalError => e
    # Notify user about display name approval needed
    user = inbox.chatbot.user
    UserNotifierMailer.with(user: user, channel: inbox.channel).display_name_approval_needed.deliver_later
  rescue WhatsappSdk::Api::Responses::HttpResponseError => e
    error_message = "SendReplyJob failed for message_id: #{message.id}, and WABA #{inbox.channel.business_account_id} with error: #{e.message} for sender_id: #{inbox.channel.phone_number_id.to_i} and recipient_number: #{chat.contact.phone_number.to_i}"
    Sentry.capture_exception(e)
    raise e, error_message
  end

  def send_message_to_instagram
    Instagram::SendMessageService.new(message: @message).send_message
  end
end
