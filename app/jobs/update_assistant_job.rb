class UpdateAssistantJob < ApplicationJob
  queue_as :default

  def perform(chatbot_id, model_id, temperature, system_instructions)
    chatbot = Chatbot.find(chatbot_id)
    begin
      assistant = OpenAiService.update_assistant(chatbot.assistant_id, model_id, temperature, system_instructions)
      raise "AI agent not found" if assistant.blank?
      chatbot.update(model_id: model_id, temperature: temperature, system_instructions: system_instructions)
      broadcast_sidebar_content(chatbot, assistant)
      flash_message(:notice, "AI agent updated successfully!")
    rescue OpenAI::Error => e
      Rails.logger.error("OpenAI error updating assistant: #{e.message}")
      flash_message(:alert, "Error updating assistant: #{e.message}")
      broadcast_sidebar_content(chatbot, nil)
      raise "OpenAI error updating assistant: #{e.message}"
    end
  rescue StandardError => e
    Rails.logger.error("Error updating assistant: #{e.message}")
    flash_message(:alert, "Error updating assistant: #{e.message}")
    broadcast_sidebar_content(chatbot, nil)
    raise "Error updating assistant: #{e.message}"
  end

  private

  def broadcast_sidebar_content(chatbot, assistant)
    Turbo::StreamsChannel.broadcast_replace_to(
      "playground_sidebar",
      target: "sidebar_skeleton",
      partial: "chatbots/playground/sidebar_content",
      locals: {
        chatbot: chatbot,
        assistant: assistant
      }
    )
  end

  def flash_message(type, message)
    Turbo::StreamsChannel.broadcast_update_to(
      "playground_sidebar",
      target: "flash",
      partial: "shared/flash_messages",
      locals: { flash: { "#{type}": message } }
    )
  end
end
