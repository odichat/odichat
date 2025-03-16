class CreateOpenAiAssistantJob < ApplicationJob
  queue_as :default

  def perform(chatbot_id)
    chatbot = Chatbot.find(chatbot_id)

    begin
      client = OpenAI::Client.new
      assistant = client.assistants.create(
        parameters: {
          model: Model.find(chatbot.model_id).name,
          name: chatbot.name,
          instructions: chatbot.system_instructions,
          tools: [],
          temperature: chatbot.temperature
        }
      )
      chatbot.update!(assistant_id: assistant["id"])
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
