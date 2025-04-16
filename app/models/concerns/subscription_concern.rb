module SubscriptionConcern
  extend ActiveSupport::Concern

  included do
    def check_subscription_status
      subscription = payment_processor&.subscription&.processor_subscription
      return if subscription.blank?

      update(
        subscription_status: subscription.status,
        subscription_end_date: Time.at(subscription.current_period_end),
        subscription_start_date: Time.at(subscription.current_period_start)
      )
    end

    def active_subscription
      check_subscription_status if subscription_end_date.blank? || subscription_end_date < Time.current
      subscription_end_date.nil? ? false : subscription_end_date > Time.current
    end
  end
end
