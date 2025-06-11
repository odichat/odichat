class Llm::AssistantResponseJob < ApplicationJob
  queue_as :default

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
