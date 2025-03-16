class Chatbot < ApplicationRecord
  belongs_to :user

  before_create :set_default_system_instructions

  validates :model_id, presence: true
  validates :temperature, presence: true
  validates :temperature, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }

  after_create :create_assistant

  private

  def set_default_system_instructions
    self.system_instructions = "You are a helpful assistant."
  end

  def create_assistant
    puts "Creating assistant for chatbot #{self.id}"
    return if self.assistant_id.present?
    puts "Assistant ID is present for chatbot #{self.id}"

    # Enqueue job to create the assistant
    CreateOpenAiAssistantJob.perform_later(self.id)
  end
end
