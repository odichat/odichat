class Chatbots::Integrations::WabasController < Chatbots::BaseController
  before_action :set_waba, only: [ :edit, :update ]

  def edit
    @business_profile = @chatbot.waba.get_business_profile
    @connected_phone_number = @chatbot.waba.get_connected_phone_number
  end

  def update
    if @chatbot.waba.update_business_profile(business_profile_params)
      respond_to do |format|
        format.turbo_stream {
          flash.now[:notice] = "Business profile updated successfully"
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash_messages"),
            turbo_stream.update("business_profile_form", partial: "form", locals: { chatbot: @chatbot, business_profile: @chatbot.waba.get_business_profile })
          ]
        }
      end
    else
      respond_to do |format|
        format.turbo_stream {
          flash.now[:alert] = "Failed to update business profile"
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash_messages"),
            turbo_stream.update("business_profile_form", partial: "form", locals: { chatbot: @chatbot, business_profile: @chatbot.waba.get_business_profile })
          ]
        }
      end
    end
  rescue StandardError => e
    respond_to do |format|
      format.turbo_stream {
        flash.now[:alert] = e.message
        render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
      }
    end
  end

  private

  def business_profile_params
    params.permit(:profile_picture_handle, :about, :address, :description, :email, :websites, :vertical)
  end

  def set_waba
    @waba = @chatbot.waba
  end
end
