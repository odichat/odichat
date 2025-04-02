class Chatbot < ApplicationRecord
  belongs_to :user

  has_one :wa_integration, dependent: :destroy

  has_many :chats, dependent: :destroy
  has_many :documents, dependent: :destroy

  validates :model_id, presence: true
  validates :temperature, presence: true
  validates :temperature, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2 }

  before_create :set_default_system_instructions
  before_create :set_default_temperature

  after_create :create_assistant
  after_create :create_playground_chat

  after_destroy :delete_assistant
  after_destroy :delete_vector_store

  private

  def set_default_system_instructions
    self.system_instructions = "You are a helpful assistant."
  end

  def set_default_temperature
    self.temperature = 1.0
  end

  def create_assistant
    return if self.assistant_id.present?
    # Enqueue job to create the assistant
    CreateOpenAiAssistantJob.perform_later(self.id)
  end

  def create_playground_chat
    return if self.chats.one?
    chats.create!(source: "playground")
  end

  def delete_assistant
    return if self.assistant_id.blank?
    DeleteAssistantJob.perform_later(self.assistant_id)
  end

  def delete_vector_store
    return if self.vector_store_id.blank?
    DeleteVectorStoreJob.perform_later(self.vector_store_id)
  end
end
