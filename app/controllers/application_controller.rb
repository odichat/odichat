class ApplicationController < ActionController::Base
  layout "application"
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from NoMethodError, ArgumentError, with: :handle_error
  rescue_from WhatsappSdk::Api::Responses::HttpResponseError, with: :handle_whatsapp_api_error

  private

  protected

  def handle_error
    respond_with_error(500)
  end

  def handle_whatsapp_api_error
    respond_with_error(500)
  end

  def respond_with_error(code)
    respond_to do |format|
      format.any  { render "errors/#{code}", layout: "error", status: code, formats: [ :html ] }
      format.json { render json: { error: Rack::Utils::HTTP_STATUS_CODES[code] }, status: code }
    end
  end
end
