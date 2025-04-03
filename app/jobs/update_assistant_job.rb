class UpdateAssistantJob < ApplicationJob
  queue_as :default

  def perform(chatbot_id, model_id, temperature, system_instructions)
    chatbot = Chatbot.find(chatbot_id)

    begin
      # OpenAI API call to update the assistant
      assistant = OpenAiService.update_assistant(chatbot.assistant_id, model_id, temperature, system_instructions)

      if assistant.present?
        # Only update the database if the API call was successful
        chatbot.update!(
          model_id: model_id,
          temperature: temperature,
          system_instructions: system_instructions
        )
        flash_message(:notice, "AI agent updated successfully!")
      else
        flash_message(:alert, "Failed to update AI agent: No response received")
      end

    rescue OpenAI::Error => e
      Rails.logger.error("OpenAI error updating assistant: #{e.message}")
      flash_message(:alert, "Error updating assistant: #{e.message}")
    rescue StandardError => e
      Rails.logger.error("Error updating assistant: #{e.message}")
      flash_message(:alert, "Error updating assistant: #{e.message}")
    ensure
      # Broadcast the sidebar form to update the button text, which is a spinner
      broadcast_sidebar_form(chatbot)
    end
  end

  private

  def broadcast_sidebar_form(chatbot)
    Turbo::StreamsChannel.broadcast_replace_to(
      "playground_sidebar",
      target: "sidebar_form",
      partial: "chatbots/playground/sidebar/form",
      locals: {
        chatbot: chatbot
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
