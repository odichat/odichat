class Chatbot < ApplicationRecord
  belongs_to :user

  before_create :set_default_system_instructions

  validates :model_id, presence: true
  validates :temperature, presence: true
  validates :temperature, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }

  after_create :create_assistant
  after_update :update_assistant

  private

  def set_default_system_instructions
    self.system_instructions = "You are a helpful assistant."
  end

  def create_assistant
    return if self.assistant_id.present?
    # Enqueue job to create the assistant
    CreateOpenAiAssistantJob.perform_later(self.id)
  end

  def update_assistant
    return if self.assistant_id.blank?
    # TODO: Update the assistant
  end
end
