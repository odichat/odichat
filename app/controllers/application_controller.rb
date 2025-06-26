class ApplicationController < ActionController::Base
  layout "application"

  include Pundit::Authorization
  before_action :set_locale

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from NoMethodError, ArgumentError, with: :handle_error
  rescue_from WhatsappSdk::Api::Responses::HttpResponseError, with: :handle_whatsapp_api_error
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  protected

  # **************************************************
  # Locale
  # **************************************************
  # We are only doing this, hardcoded, for a single customer from Manchester, UK.
  def set_locale
    if current_user.present? && current_user.email.include?("@fiftysixlaw.co.uk")
      I18n.locale = :en
    end
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
