class Llm::EmbeddingService
  class EmbeddingsError < StandardError; end

  def generate_embedding(content)
    embedding = RubyLLM.embed(
      content,
      model: "text-embedding-3-small",
      dimensions: 1536
    )

    embedding.vectors
  rescue StandardError => e
    Rails.logger.error("Failed to generate embedding: #{e.message}")
    raise EmbeddingsError, "Failed to generate embedding: #{e.message}"
  end
end
