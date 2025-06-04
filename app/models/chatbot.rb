class Chatbot < ApplicationRecord
  belongs_to :user

  has_one :waba, dependent: :destroy
  has_one :vector_store, dependent: :destroy
  has_one :shareable_link, dependent: :destroy

  has_many :chats, dependent: :destroy
  has_many :documents, dependent: :destroy

  validates :model_id, presence: true
  validates :temperature, presence: true
  validates :temperature, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2 }

  before_create :set_default_system_instructions
  before_create :set_default_temperature

  after_create :create_shareable_link
  after_create :create_vector_store
  after_create :create_playground_chat
  after_create :create_public_playground_chat

  after_destroy :enqueue_cleanup_job

  def public_url
    Rails.application.routes.url_helpers.public_playground_url(token: shareable_link.token)
  end

  def time_aware_instructions
    return if !is_time_aware? || timezone.blank?
    <<~SYSTEM_INSTRUCTIONS
      #### Metadata
      Current time is #{Time.now.in_time_zone(timezone).strftime("%H:%M")}.
    SYSTEM_INSTRUCTIONS
  end

  private

  # **************************************************
  # Callbacks
  # **************************************************
  def set_default_system_instructions
    self.system_instructions = "You are a helpful assistant."
  end

  def set_default_temperature
    self.temperature = 1.0
  end

  def create_shareable_link
    ShareableLink.create!(chatbot: self, token: SecureRandom.uuid)
  end

  def create_vector_store
    VectorStore.create!(chatbot: self, name: "#{self.name.parameterize}:#{self.id}")
  end

  def create_playground_chat
    return if self.chats.where(source: "playground").any?
    chats.create!(source: "playground")
  end

  def create_public_playground_chat
    return if self.chats.where(source: "public_playground").any?
    chats.create!(source: "public_playground")
  end

  def enqueue_cleanup_job
    HandleChatbotCleanupJob.perform_later(
      documents.pluck(:file_id),
      vector_store.vector_store_id
    )
  end
end
