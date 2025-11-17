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
  after_create :create_faq_scenario
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

        #{lead_qualification_instructions if self.user.email == "andres@odichat.app"}

        # Current Conversation Context:**
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
    tools = []
    if self.user.email == "andres@odichat.app"
      tools << Llm::Tools::CreateLeadTool.new
    end
    tools
  end

  def agent_response_schema
    Chatbot::ResponseSchema
  end

  private

  def lead_qualification_instructions
    <<~LEAD_INSTRUCTIONS
      # Lead Qualification Criteria
      Apply the `create_lead` when the following conditions are met:
      1. Si hay interés de compra (ej. “quiero contratar”, “necesito el servicio”, “estoy interesado, cómo puedo comunicarme con ustedes?”).
      2. Antes de registrar un lead, asegúrate de preguntar la siguiente información:
        - Nombre del negocio o empresa
        - Nicho/industria
        - Objetivo principal (ej. ventas, soporte)
      3. Si falta alguno de esos datos, formula preguntas breves para obtenerlos.
      4. Antes de crear el lead confirma dos condiciones: (a) el mensaje que estás escribiendo ya contiene el enlace https://wa.me/+13052139902 y (b) has mencionado explícitamente que el equipo comercial dará seguimiento. Si cualquiera falta, no llames al tool.

      **Lead Qualification Guardrails:**
      - Do not call the `create_lead` tool unless all criteria below are satisfied.
      - Once you create the lead, avoid re-opening the qualification; focus the conversation in answering customer questions only.
    LEAD_INSTRUCTIONS
  end

  # **************************************************
  # Callbacks
  # **************************************************
  def set_default_system_instructions
    self.system_instructions ||= "You are #{self.name}, a helpful customer support agent for [YOUR_COMPANY]. Your role is to provide accurate information about our business, products and services using your access to the FAQs and products database."
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
      description: "If the user asks for product specifications, details, information and/or pricing use the `handoff_to_sales_agent` function.",
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

  def create_faq_scenario
    scenario = self.scenarios.build(
      name: "FAQs Agent",
      description: "If the request is about general information or common questions, use the `handoff_to_faq_agent` function.",
      tools: [ "faq_lookup" ]
    )

    instruction = <<~INSTRUCTIONS
      You are the FAQ Agent. Answer frequently asked questions using the curated knowledge base.
      **Your tools:**
      #{scenario.render_tool_section}

      **Instructions:**
      - Provide concise, helpful answers.
      - If the knowledge base does not cover the query, acknowledge the limitation.
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
