class User < ApplicationRecord
  include SubscriptionConcern
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :chatbots, dependent: :destroy

  pay_customer stripe_attributes: :stripe_attributes

  def stripe_attributes(pay_customer)
    {
      address: {
        city: pay_customer.owner.city,
        country: pay_customer.owner.country
      },
      metadata: {
        pay_customer_id: pay_customer.id,
        user_id: id # or pay_customer.owner_id
      }
    }
  end

  def basic_plan?
    payment_processor&.subscribed?(processor_plan: Rails.application.credentials.dig(:stripe, :plans, :basic_monthly))
  end

  def pro_plan?
    payment_processor&.subscribed?(processor_plan: Rails.application.credentials.dig(:stripe, :plans, :pro_monthly))
  end

  def subscribed?
    payment_processor&.subscribed?
  end

  def not_subscribed_and_has_one_chatbot?
    !subscribed? && chatbots.count >= 1
  end
end
