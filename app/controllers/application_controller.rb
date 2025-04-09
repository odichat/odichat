class ApplicationController < ActionController::Base
  layout "application"
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from NoMethodError, ArgumentError, with: :handle_error
  rescue_from WhatsappSdk::Api::Responses::HttpResponseError, with: :handle_whatsapp_api_error

  protected

  def handle_error(exception)
    error_message = "Error: #{exception.message}"
    respond_with_error(500, error_message)
  end

  def handle_whatsapp_api_error(exception)
    error_message = exception.body.dig("error", "message") || "WhatsApp API Error"
    error_code = exception.body.dig("error", "code") || 500
    respond_with_error(error_code, error_message)
  end

  def respond_with_error(code, message)
    respond_to do |format|
      format.any  { render "errors/error", layout: "error", status: code, locals: { status: code, message: message }, formats: [ :html ] }
      format.json { render json: { error: Rack::Utils::HTTP_STATUS_CODES[code], message: message }, status: code }
    end
  end
end
