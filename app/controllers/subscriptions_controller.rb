class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def show
    @portal_session = current_user.payment_processor.billing_portal
    redirect_to @portal_session.url, allow_other_host: true
  end

  def checkout
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

    redirect_to @checkout_session.url, allow_other_host: true
  end

  def success
    # At this point, if the user is not subscribed we have to manually sync the subscription
    unless current_user&.payment_processor&.subscribed?
      Pay::Stripe::Subscription.sync_from_checkout_session(params[:stripe_checkout_session_id])
    end
    redirect_to root_path, notice: "🎉🎉🎉 Hooray! You're now subscribed. 🎉🎉🎉"
  end

  def cancel
    redirect_to root_path
  end

  private

  def subscription_params
    params.permit(:price_id)
  end
end
