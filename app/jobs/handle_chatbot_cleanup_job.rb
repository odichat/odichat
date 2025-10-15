class HandleChatbotCleanupJob < ApplicationJob
  queue_as :low
  retry_on OpenAI::Error, wait: :polynomially_longer, attempts: 5, priority: :low

  def perform(file_ids, vector_store_id)
    return if file.ids.size.zero? || file_ids.nil?
    return if vector_store_id.nil?

    begin
      file_ids.each do |file_id|
        Document.remove_from_storage(vector_store_id, file_id)
      end
      VectorStore.delete(vector_store_id)
    rescue OpenAI::Error => e
      raise "OpenAI error when deleting when cleaning up chatbot (file_ids: #{file_ids}, vector_store_id: #{vector_store_id}): #{e.message}"
    rescue StandardError => e
      raise "Failed to cleanup chatbot (file_ids: #{file_ids}, vector_store_id: #{vector_store_id}): #{e.message}"
    end
  end
end
