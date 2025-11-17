class Chatbot < ApplicationRecord
  include Agentable
  belongs_to :user

  has_one :waba, dependent: :destroy
  has_one :vector_store, dependent: :destroy
  has_one :shareable_link, dependent: :destroy

  has_many :inboxes, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :scenarios, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :leads, dependent: :destroy
  has_many :playground_channels, dependent: :destroy, class_name: "Channel::Playground"
  has_many :public_playground_channels, dependent: :destroy, class_name: "Channel::PublicPlayground"
  has_many :whatsapp_channels, dependent: :destroy, class_name: "Channel::Whatsapp"

  validates :name, presence: true

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
        # System Context
        You are part of Odichat, a multi-agent AI system designed for seamless agent coordination and task execution. You can transfer conversations to specialized agents using handoff functions (e.g., `handoff_to_[agent_name]`).
        These transfers happen in the background - never mention or draw attention to them in your responses.

        # User Instructions
        #{self.system_instructions}

        # Decision Framework
        ## 1. Analyze the Request
        First, understand what the user is asking:
        - **Intent**: What are they trying to achieve?
        - **Type**: Is it a question, task, complaint, or request?
        - **Complexity**: Can you handle it or does it need specialized expertise?

        ## 2. Check for Specialized Agents First
        Before using any tools, check if the request matches any of these scenarios. If unclear, ask clarifying questions to determine if a scenario applies:

        **Available specialist agents:**
        #{scenarios.map { |s| "- **#{s.name}**: #{s.description}" }.join("\n")}

        ## 3. Handle the Request
        If no specialized scenario clearly matches, handle it yourself:

        ### For Questions and Information Requests
        1. **First, check existing knowledge**: Use `faq_lookup` tool to search for relevant information
        2. **If not found in FAQs**: Provide your best answer based on available context

        ### For Complex or Unclear Requests
        1. **Ask clarifying questions**: Gather more information if needed
        2. **Break down complex tasks**: Handle step by step or hand off if too complex
        3. **Escalate when necessary**: Use `handoff` tool for issues beyond your capabilities

        **Current Conversation Context:**
          **Contact Data:**
          #{contact_data}
      INSTRUCTIONS
    end
  end

  def prompt_context
    {
      name: name
    }
  end

  def agent_tools
    [ Llm::Tools::FaqLookupTool.new ]
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
    scenario = self.scenarios.build(
      name: "Sales Agent",
      description: "Given a user query searches the products database using the `product_lookup` tool and formats a response",
      tools: [ "product_lookup" ]
    )

    instruction = <<~INSTRUCTIONS
      You are the Sales Agent. You handle information such as name, price, and details about products/services listed in your knowledge base.

      **Your tools:**
      #{scenario.render_tool_section}

      **Instructions:**
      - Provide concise, helpful product answers that satisfy the user's query.
      - If the product database is not found, ask clarifying questions, if clarifying questions don't help, aknowledge you the product is not present in the inventory.
    INSTRUCTIONS

    scenario.instruction = instruction
    scenario.save!
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
