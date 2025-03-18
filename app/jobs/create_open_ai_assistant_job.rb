class CreateOpenAiAssistantJob < ApplicationJob
  queue_as :default

  def perform(chatbot_id)
    chatbot = Chatbot.find(chatbot_id)

    begin
      # In development, we use a pre-existing assistant for testing purposes
      if Rails.env.production?
        client = OpenAI::Client.new
        assistant = client.assistants.create(
          parameters: {
          model: Model.find(chatbot.model_id).name,
          name: chatbot.name,
          instructions: chatbot.system_instructions,
          tools: [],
          temperature: chatbot.temperature
        })
        assistant_id = assistant["id"]
      else
        assistant_id = "asst_AFGyRQRz0BgEOW0kmjFg9wsg"
      end

      chatbot.update!(assistant_id: assistant_id)

      # Create a chat for the user to start the conversation in the playground
      CreateChatWithThreadJob.perform_later(chatbot_id, "playground")
    rescue OpenAI::Error => e
      error_message = "OpenAI::Error creating assistant for user_id `#{chatbot.user.id}` and chatbot_id `#{chatbot.id}`: #{e.message}"
      Rails.logger.error(error_message)
      raise error_message
    end
  rescue StandardError => e
    error_message = "StandardError creating assistant for user_id `#{chatbot.user.id}` and chatbot_id `#{chatbot.id}`: #{e.message}"
    Rails.logger.error(error_message)
    raise error_message
  end
end
