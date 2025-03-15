class Chatbot < ApplicationRecord
  belongs_to :user

  validates :model, presence: true
  validates :temperature, presence: true
  validates :temperature, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
end
