class Chatbot < ApplicationRecord
  belongs_to :user

  validates :model_id, presence: true
  validates :temperature, presence: true
  validates :temperature, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }

  after_create :create_assistant

  private

  def create_assistant
    return if self.assistant_id.present?
    # TODO: Enqueue a job to create the assistant
  end
end
