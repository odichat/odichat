class RemoveDocumentFromOpenaiJob < ApplicationJob
  queue_as :default

  def perform(vector_store_id, file_id)
    begin
      openai_client = OpenAI::Client.new
      openai_client.vector_store_files.delete(
        vector_store_id: vector_store_id,
        id: file_id
      )
      openai_client.files.delete(id: file_id)
    rescue OpenAI::Error => e
      Rails.logger.error("Error removing document from OpenAI: #{e.message}")
      raise "Error removing document from OpenAI: #{e.message}"
    end
  rescue StandardError => e
    Rails.logger.error("Error removing document from OpenAI: #{e.message}")
    raise "Error removing document from OpenAI: #{e.message}"
  end
end
