class Avo::Resources::Lead < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :chatbot, as: :belongs_to
    field :contact, as: :belongs_to
    field :trigger, as: :textarea
  end
end
