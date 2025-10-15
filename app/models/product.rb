class Product < ApplicationRecord
  belongs_to :product_inventory,
             class_name: "Roleable::ProductInventory",
             foreign_key: :roleable_product_inventory_id,
             inverse_of: :products

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
