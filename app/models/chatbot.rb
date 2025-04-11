class Chatbot < ApplicationRecord
  belongs_to :user

  has_one :waba, dependent: :destroy

  has_many :chats, dependent: :destroy
  has_many :documents, dependent: :destroy

  validates :model_id, presence: true
  validates :temperature, presence: true
  validates :temperature, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2 }

  before_create :set_default_system_instructions
  before_create :set_default_temperature

  after_create :create_assistant
  after_create :create_playground_chat

  after_destroy :cleanup

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

  def cleanup
    # `skip_openai_cleanup` virtual attribute to true to prevent Document callbacks from running
    documents.update_all(skip_openai_cleanup: true)

    document_ids = self.documents.pluck(:id)
    HandleChatbotCleanupJob.perform_later(
      self.assistant_id,
      document_ids,
      self.vector_store_id
    )
  end
end
