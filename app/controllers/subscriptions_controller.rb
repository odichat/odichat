class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @portal_session = current_user.payment_processor.billing_portal
  end

  def show
    current_user.set_payment_processor :stripe

    @checkout_session = current_user.payment_processor.checkout(
      mode: "subscription",
      locale: I18n.locale,
      line_items: [
        {
          price: subscription_params[:price_id],
          quantity: 1
        }
      ],
      subscription_data: {
        trial_period_days: 7
      },
      success_url: subscriptions_success_url,
      cancel_url: subscriptions_cancel_url
    )
  end

  def success
  end

  def cancel
    redirect_to subscriptions_path(price_id: "price_1REDkkCrK57Omz3Ai3F1Dtv1")
  end

  private

  def subscription_params
    params.permit(:price_id)
  end
end
