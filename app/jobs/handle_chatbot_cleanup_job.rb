class HandleChatbotCleanupJob < ApplicationJob
  queue_as :default

  def perform(assistant_id, document_ids, vector_store_id)
    begin
      openai_client = OpenAI::Client.new
      openai_client.assistants.delete(id: assistant_id)
      openai_client.vector_stores.delete(id: vector_store_id)
      document_ids.each do |document_id|
        openai_client.files.delete(id: document_id)
      end
    rescue OpenAI::Error => e
      raise "OpenAI error when deleting when cleaning up chatbot (assistant_id: #{assistant_id}, document_ids: #{document_ids}, vector_store_id: #{vector_store_id}): #{e.message}"
    rescue StandardError => e
      raise "Failed to cleanup chatbot (assistant_id: #{assistant_id}, document_ids: #{document_ids}, vector_store_id: #{vector_store_id}): #{e.message}"
    end
  end
end
