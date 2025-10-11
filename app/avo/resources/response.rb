class Avo::Resources::Response < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :chatbot, as: :belongs_to
    field :question, as: :text
    field :answer, as: :text
  end
end
