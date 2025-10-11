class Llm::EmbeddingJob < ApplicationJob
  queue_as :default

  def perform(record, content)
    vector = Llm::EmbeddingService.new.generate_embedding(content)
    record.update!(embedding: vector)
  end
end
