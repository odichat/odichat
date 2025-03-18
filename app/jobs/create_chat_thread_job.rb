class CreateChatThreadJob < ApplicationJob
  queue_as :default

  def perform(chat_id)
    chat = Chat.find(chat_id)

    begin
      client = OpenAI::Client.new
      thread = client.threads.create

      chat.update!(thread_id: thread["id"])
    rescue OpenAI::Error => e
      error_message = "OpenAI::Error creating chat for user_id `#{chat.chatbot.user.id}` and chatbot_id `#{chat.chatbot.id}`: #{e.message}"
      Rails.logger.error(error_message)
      raise error_message
    end
  rescue StandardError => e
    error_message = "StandardError creating chat for user_id `#{chat.chatbot.user.id}` and chatbot_id `#{chat.chatbot.id}`: #{e.message}"
    Rails.logger.error(error_message)
    raise error_message
  end
end
