class Avo::Resources::User < Avo::BaseResource
  self.title = :email
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :email, as: :text
    field :name, as: :text
    field :city, as: :text
    field :country, as: :country
    field :subscription_status, as: :text
    field :subscription_end_date, as: :date_time
    field :subscription_start_date, as: :date_time
    field :role, as: :select, enum: ::User.roles
    field :chatbots, as: :has_many
    # field :pay_customers, as: :has_many
    # field :charges, as: :has_many, through: :pay_customers
    # field :subscriptions, as: :has_many, through: :pay_customers
    # field :payment_processor, as: :has_one
  end
end
