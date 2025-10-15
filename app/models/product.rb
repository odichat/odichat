class Product < ApplicationRecord
  belongs_to :product_inventory,
             class_name: "Roleable::ProductInventory",
             foreign_key: :roleable_product_inventory_id,
             inverse_of: :products

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  has_neighbors :embedding, normalize: true

  after_commit :generate_embedding, on: [ :create, :update ]

  def self.search(query)
    embedding = Llm::EmbeddingService.new.generate_embedding(query)
    nearest_neighbors(:embedding, embedding, distance: :cosine).limit(3)
  end

  private

    def generate_embedding
      return unless saved_change_to_name? || saved_change_to_description? || embedding.nil?

      Llm::EmbeddingJob.perform_later(self, "Name: #{self.name}. Description: #{self.description}")
    end
end
