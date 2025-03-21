class ApplicationController < ActionController::Base
  layout "application"
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from NoMethodError, ArgumentError do |exception|
    error_message = Rails.env.production? ? "Sorry, something went wrong. If the error persists, please contact support." : "Error: #{exception.message}"
    respond_to do |format|
      format.html { redirect_to root_path, alert: error_message }
      format.turbo_stream {
        flash.now[:alert] = error_message
        render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
      }
    end
  end
end
