class ApplicationController < ActionController::Base
  layout "application"

  include Pundit::Authorization

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from NoMethodError, ArgumentError, with: :handle_error
  rescue_from WhatsappSdk::Api::Responses::HttpResponseError, with: :handle_whatsapp_api_error
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  protected

  # **************************************************
  # Devise
  # **************************************************

  def after_sign_in_path_for(resource)
    if current_user&.payment_processor&.subscribed?
      chatbots_path
    else
      subscriptions_pricing_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :city, :country ])
  end

  # **************************************************
  # Error handling
  # **************************************************

  def handle_error(e)
    respond_with_error(500, e)
  end

  def handle_whatsapp_api_error(e)
    respond_with_error(500, e)
  end

  def user_not_authorized(e)
    respond_with_error(403, e)
  end

  def respond_with_error(code, error = nil)
    respond_to do |format|
      format.any  { render "errors/#{code}", layout: "error", status: code, formats: [ :html ], locals: { error: error } }
      format.json { render json: { error: Rack::Utils::HTTP_STATUS_CODES[code] }, status: code }
    end
  end
end
