class FetchAssistantJob < ApplicationJob
  queue_as :default

  def perform(chatbot_id)
    chatbot = Chatbot.find(chatbot_id)
    begin
      assistant = OpenAiService.get_assistant(chatbot.assistant_id)
      if assistant.present?
        Rails.logger.info("Broadcasting sidebar content")
        Turbo::StreamsChannel.broadcast_replace_to(
          "playground_sidebar",
          target: "playground_sidebar",
          partial: "chatbots/playground/sidebar_content",
          locals: {
            chatbot: chatbot,
            assistant: assistant
          }
        )
      end
    rescue OpenAI::Error => e
      Rails.logger.error("OpenAI error getting assistant: #{e.message}")
      raise "OpenAI error getting assistant: #{e.message}"
    end
  rescue StandardError => e
    Rails.logger.error("Error fetching assistant: #{e.message}")
    Turbo::StreamsChannel.broadcast_update_to(
      "playground_sidebar",
      target: "flash",
      partial: "shared/flash_messages",
      locals: { type: "alert", message: "Error fetching assistant: #{e.message}" }
    )
    raise "Error fetching assistant: #{e.message}"
  end
end
