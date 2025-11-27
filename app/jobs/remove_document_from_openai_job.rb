class RemoveDocumentFromOpenaiJob < ApplicationJob
  queue_as :default
  retry_on OpenAI::Error, wait: :polynomially_longer, attempts: 3

  def perform(vector_store_id, file_id)
    raise "Missing vector store id" if vector_store_id.blank?
    raise "Missing file id" if file_id.blank?
    Document.remove_from_storage(vector_store_id, file_id)
  end
end
