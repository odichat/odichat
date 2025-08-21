class Llm::AssistantResponseJob < ApplicationJob
  queue_as :default

  retry_on Faraday::ServerError, wait: :polynomially_longer, attempts: 3

  def perform(message_id)
    message = Message.includes(chat: :chatbot).find(message_id)
    chat = message.chat
    chatbot = chat.chatbot

    Llm::AssistantResponseService.new(
      input_message: message.content,
      chat: chat,
      chatbot: chatbot,
    ).generate_response
  end
end
