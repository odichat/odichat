class Chatbot < ApplicationRecord
  belongs_to :user

  has_one :waba, dependent: :destroy
  has_one :vector_store, dependent: :destroy
  has_one :shareable_link, dependent: :destroy

  has_many :inboxes, dependent: :destroy_async
  has_many :chats, dependent: :destroy_async
  has_many :contacts, dependent: :destroy_async
  has_many :documents, dependent: :destroy_async
  has_many :playground_channels, dependent: :destroy_async, class_name: "Channel::Playground"
  has_many :public_playground_channels, dependent: :destroy_async, class_name: "Channel::PublicPlayground"
  has_many :whatsapp_channels, dependent: :destroy_async, class_name: "Channel::Whatsapp"

  validates :model_id, presence: true
  validates :temperature, presence: true
  validates :temperature, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2 }

  before_create :set_default_system_instructions
  before_create :set_default_temperature

  after_create :create_shareable_link
  after_create :create_vector_store
  after_create :create_playground_resources
  after_create :create_public_playground_resources

  after_destroy :enqueue_cleanup_job

  def public_url
    Rails.application.routes.url_helpers.public_playground_url(token: shareable_link.token)
  end

  def time_aware_instructions
    return "" if !is_time_aware? || timezone.blank?
    <<~SYSTEM_INSTRUCTIONS
      #### Metadata
      - Current time is #{Time.now.in_time_zone(timezone).strftime("%H:%M")}.
    SYSTEM_INSTRUCTIONS
  end

  def is_time_aware?
    true
  end

  def additional_system_instructions
    <<~SYSTEM_INSTRUCTIONS
      - Do not include documents references or citations in your responses, here's an example: `【34:citation/reference"】`.
      Anything that looks like a citation or reference should be removed from the response.
    SYSTEM_INSTRUCTIONS
  end

  def last_playground_chat
    playground_inbox&.chats&.last
  end

  def last_public_playground_chat
    public_playground_inbox&.chats&.last
  end

  def playground_inbox
    playground_channels&.first&.inbox
  end

  def public_playground_inbox
    public_playground_channels&.first&.inbox
  end

  def whatsapp_inbox
    whatsapp_channels&.first&.inbox
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

  # **************************************************
  # Playground
  # **************************************************

  def create_playground_resources
    channel = find_or_create_playground_channel
    inbox = find_or_create_playground_inbox(channel)
    create_playground_chat_for_inbox(inbox)
  end

  def find_or_create_playground_channel
    playground_channels.first_or_create!
  end

  def find_or_create_playground_inbox(channel)
    channel.inbox || inboxes.create!(channel: channel)
  end

  def create_playground_chat_for_inbox(inbox)
    return if inbox.chats.where(source: "playground").exists?
    inbox.chats.create!(chatbot: self, source: "playground")
  end

  # **************************************************
  # Public Playground
  # **************************************************

  def create_public_playground_resources
    channel = find_or_create_public_playground_channel
    inbox = find_or_create_public_playground_inbox(channel)
    create_public_playground_chat_for_inbox(inbox)
  end

  def find_or_create_public_playground_channel
    public_playground_channels.first_or_create!
  end

  def find_or_create_public_playground_inbox(channel)
    channel.inbox || inboxes.create!(channel: channel)
  end

  def create_public_playground_chat_for_inbox(inbox)
    return if inbox.chats.where(source: "public_playground").exists?
    inbox.chats.create!(chatbot: self, source: "public_playground")
  end

  # **************************************************
  # Cleanup
  # **************************************************

  def enqueue_cleanup_job
    HandleChatbotCleanupJob.perform_later(
      documents.pluck(:file_id),
      vector_store.vector_store_id
    )
  end
end
