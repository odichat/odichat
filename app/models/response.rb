class Response < ApplicationRecord
  belongs_to :faq,
            class_name: "Roleable::Faq",
            foreign_key: :roleable_faq_id,
            inverse_of: :responses

  validates :question, presence: true
  validates :answer, presence: true

  has_neighbors :embedding, normalize: true

  after_commit :generate_embedding, on: [ :create, :update ]

  def self.search(query)
    embedding = Llm::EmbeddingService.new.generate_embedding(query)
    nearest_neighbors(:embedding, embedding, distance: :cosine).limit(3)
  end

  private

    def generate_embedding
      return unless saved_change_to_question? || saved_change_to_answer? || embedding.nil?

      Llm::EmbeddingJob.perform_later(self, "#{question}: #{answer}")
    end
end
