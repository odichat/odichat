class SendReplyJob < ApplicationJob
  queue_as :default

  attr_reader :message, :chat, :waba

  def perform(message_id)
    @message = Message.includes(chat: [ :contact, { chatbot: :waba } ]).find(message_id)
    @chat = message.chat
    @waba = chat.chatbot.waba

    send_message_to_channel
  end

  private

  def send_message_to_channel
    send_message_to_whatsapp if chat.whatsapp_channel?
    send_message_to_playground if chat.playground_channel?
    send_message_to_public_playground if chat.public_playground_channel?
  end

  def send_message_to_whatsapp
    response = Whatsapp::SendMessageService.new(access_token: waba.access_token).send_message(
      sender_id: waba.phone_number_id.to_i,
      recipient_number: chat.contact.phone_number.to_i,
      message: message.content
    )
    message.update(source_id: response.messages&.first&.id)
  rescue WhatsappSdk::Api::Responses::HttpResponseError => e
    error_message = "SendReplyJob failed for message_id: #{message.id}, and WABA #{waba.id} with error: #{e.message} for sender_id: #{waba.phone_number_id.to_i} and recipient_number: #{chat.contact.phone_number.to_i}"
    Sentry.capture_exception(e)
    raise e, error_message
  end

  def send_message_to_playground
    Turbo::StreamsChannel.broadcast_append_to(
      "chat_#{chat.id}_messages",
      target: "messages",
      partial: "messages/message",
      locals: { message: message }
    )
  end

  def send_message_to_public_playground
    Turbo::StreamsChannel.broadcast_append_to(
      "public_chat_#{chat.id}_messages",
      target: "messages",
      partial: "public/messages/message",
      locals: { message: message }
    )
  end
end
