class Chatbot < ApplicationRecord
  include Agentable
  belongs_to :user

  has_one :waba, dependent: :destroy
  has_one :vector_store, dependent: :destroy
  has_one :shareable_link, dependent: :destroy

  has_many :inboxes, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :scenarios, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :playground_channels, dependent: :destroy, class_name: "Channel::Playground"
  has_many :public_playground_channels, dependent: :destroy, class_name: "Channel::PublicPlayground"
  has_many :whatsapp_channels, dependent: :destroy, class_name: "Channel::Whatsapp"

  validates :name, presence: true
  validates :model_id, presence: true

  before_create :set_default_system_instructions
  before_create :set_default_temperature

  after_create :create_shareable_link
  # after_create :create_vector_store
  after_create :create_playground_resources
  after_create :create_public_playground_resources
  after_create :create_product_scenario

  after_destroy :enqueue_cleanup_job

  def public_url
    Rails.application.routes.url_helpers.public_playground_url(token: shareable_link.token)
  end

  def time_aware_instructions
    return "" if !is_time_aware? || timezone.blank?
    <<~SYSTEM_INSTRUCTIONS
      #### Metadata
      - Current time is #{Time.now.in_time_zone(timezone).strftime("%H:%M")}.\n
    SYSTEM_INSTRUCTIONS
  end

  def formatting_instructions
    <<~FORMATTING_INSTRUCTIONS
      Formatting re-enabled\n
    FORMATTING_INSTRUCTIONS
  end

  def additional_system_instructions
    <<~SYSTEM_INSTRUCTIONS
      - Do not include documents references or citations in your responses, here's an example: `【34:citation/reference"】`.
      Anything that looks like a citation or reference should be removed from the response.\n
    SYSTEM_INSTRUCTIONS
  end

  def aggregated_system_instructions
    self.formatting_instructions + self.system_instructions + self.time_aware_instructions + self.additional_system_instructions
  end

  def is_time_aware?
    true
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

  def self.timezone_options
    desired_iana_timezones = [
      "America/Chicago",         # Central Time (US)
      "America/Mexico_City",     # Mexico City
      "America/Monterrey",       # Monterrey
      "America/Bogota",          # Bogota
      "America/Argentina/Buenos_Aires", # Buenos Aires
      "America/Montevideo",      # Montevideo
      "America/Caracas",         # Caracas
      "America/Lima",            # Lima
      "America/Guayaquil"        # Quito (Ecuador mainland time)
    ]

    desired_iana_timezones.map do |iana_name|
      tz = ActiveSupport::TimeZone[iana_name]
      if tz
        # tz.to_s will give a string like "(GMT-05:00) Central Time (US & Canada)"
        [ tz.to_s, iana_name ]
      else
        # Fallback in case an IANA name is not recognized
        [ iana_name, iana_name ]
      end
    end.sort_by(&:first).to_h
  end

  # Agentable
  def agent_name
    name
  end

  def agent_model
    Agents.configuration.default_model
  end

  def agent_temperature
    temperature
  end

  def agent_instructions(context = nil)
    if context.present?
      state = context.context[:state]
      chat_data = state[:chat] || {}
      contact_data = state[:contact] || {}
      composed_context = prompt_context.merge(
        contact: contact_data
      )

      <<~INSTRUCTIONS
        # Your Identity
        You are #{agent_name}, a helpful and knowledgeable assistant.
        Your role is to provide accurate information, and ensure users get the help they need.

        Use all the available tools at your disposal for solving customer issues.

        If you are to state something factual ensure you source that information from the FAQs only (Use the faq_lookup tool for this), or route to a specialist agent.

        **Available specialist agents:**
        #{scenarios.map { |s| "- **#{s.name}**: #{s.description}" }.join("\n")}

        # Current Context
        Here's the metadata we have about the current conversation and the contact associated with it:

        ## Contact context
        #{contact_data}

        # Decision Framework
        ## 1. Analyze the Request
        First, understand what the user is asking:
        - **Intent**: What are they trying to achieve?
        - **Complexity**: Can you handle it or does it need specialized expertise?

        ## 2. Handle the Request
        ### For General Questions and Information Requests
        1. **First, check existing knowledge**: Use `faq_lookup` tool to search for relevant information
        2. **If not found in FAQs**: Provide your best answer based on available context
        

        ### For Complex or Unclear Requests
        1. **Ask clarifying questions**: Gather more information if needed
        2. **Break down complex tasks**: Handle step by step or hand off if too complex


        ## Response Best Practices
        - Be conversational but professional
        - Provide actionable information
        - Include relevant details from tool responses

      INSTRUCTIONS
    end
  end

  def prompt_context
    {
      name: name
    }
  end

  def agent_tools
    [
      Llm::Tools::FaqLookupTool.new
    ]
  end

  def agent_response_schema
    Chatbot::ResponseSchema
  end

  private

  # **************************************************
  # Callbacks
  # **************************************************
  def set_default_system_instructions
    self.system_instructions ||= "You are a helpful assistant."
  end

  def set_default_temperature
    self.temperature ||= 0.5
  end

  def create_shareable_link
    ShareableLink.create!(chatbot: self, token: SecureRandom.uuid)
  end

  def create_vector_store
    VectorStore.create!(chatbot: self, name: "#{self.name.parameterize}:#{self.id}")
  end

  def create_product_scenario
    inventory_role = Roleable::ProductInventory.create!(chatbot: self)

    scenarios.create!(
      name: "Product Inventory Agent",
      description: "Given a user query searches the products database using the `product_lookup` tool and formats a response",
      roleable: inventory_role
    )
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
      vector_store&.vector_store_id
    )
  end
end
