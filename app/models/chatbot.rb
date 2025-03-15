class Chatbot < ApplicationRecord
  belongs_to :user

  before_validation :set_default_model_id, on: :create

  validates :model_id, presence: true
  validates :temperature, presence: true
  validates :temperature, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }

  private

  def set_default_model_id
    # gpt-4o-mini is the default model
    self.model_id ||= Model.first&.id
  end
end
