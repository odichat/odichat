require "csv"

class Product < ApplicationRecord
  belongs_to :chatbot

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  has_neighbors :embedding, normalize: true

  after_commit :generate_embedding, on: [ :create, :update ]

  def self.search(query)
    embedding = Llm::EmbeddingService.new.generate_embedding(query)
    nearest_neighbors(:embedding, embedding, distance: :cosine).limit(3)
  end

  def self.import_from_csv(file, chatbot_id)
    created_count = 0

    CSV.foreach(file.path, headers: true) do |row|
      normalized = row.to_h.transform_keys { |key| key.to_s.strip.downcase }

      product_attributes = {
        name: normalized["name"],
        description: normalized["description"],
        price: normalized["price"],
        chatbot_id: chatbot_id
      }

      Product.create!(product_attributes)
      created_count += 1
    end

    created_count
  end

  private

    def generate_embedding
      return unless saved_change_to_name? || saved_change_to_description? || saved_change_to_price? || embedding.nil?

      Llm::EmbeddingJob.perform_later(self, "Name: #{self.name}. Description: #{self.description}. Price: #{self.price}")
    end
end
