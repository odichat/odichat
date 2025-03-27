class DeleteAssistantJob < ApplicationJob
  queue_as :default

  def perform(assistant_id)
    OpenAiService.delete_assistant(assistant_id)
  rescue StandardError => e
    Rails.logger.error("OpenAI error deleting assistant: #{e.message}")
    raise "OpenAI error deleting assistant: #{e.message}"
  end
end
