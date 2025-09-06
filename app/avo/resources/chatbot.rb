class Avo::Resources::Chatbot < Avo::BaseResource
  self.title = :name
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :user, as: :belongs_to
    # field :model_id, as: :text
    # field :temperature, as: :number
    field :system_instructions, as: :textarea
    field :timezone, as: :select, enum: ::Chatbot.timezone_options
    # field :waba, as: :has_one
    # field :vector_store, as: :has_one
    # field :shareable_link, as: :has_one
    # field :inboxes, as: :has_many
    # field :chats, as: :has_many
    # field :conversations, as: :has_many
    # field :contacts, as: :has_many
    # field :documents, as: :has_many
    # field :playground_channels, as: :has_many
    # field :public_playground_channels, as: :has_many
    # field :whatsapp_channels, as: :has_many
  end
end
