class Chatbots::Integrations::WhatsappController < Chatbots::BaseController
  before_action :set_whatsapp_channel, only: [ :update, :destroy, :subscribe, :unsubscribe ]
  before_action :authorize_whatsapp_channel, only: [ :update, :destroy, :subscribe, :unsubscribe ]

  def edit
    @business_profile = @chatbot.whatsapp_inbox.channel.get_business_profile
    @connected_phone_number = @chatbot.whatsapp_inbox.channel.get_connected_phone_number
  end

  def update
    # TODO: Chatbot.whatsapp_inbox.channel should be whatsapp_channel
    if @whatsapp_channel.update_business_profile(business_profile_params)
      @business_profile = @whatsapp_channel.get_business_profile
      respond_to do |format|
        format.turbo_stream {
          flash.now[:notice] = "Business profile updated successfully"
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash_messages"),
            turbo_stream.update("business_profile_form", partial: "form", locals: { chatbot: @chatbot, business_profile: @business_profile })
          ]
        }
      end
    else
      respond_to do |format|
        @business_profile = @whatsapp_channel.get_business_profile
        format.turbo_stream {
          flash.now[:alert] = "Failed to update business profile"
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash_messages"),
            turbo_stream.update("business_profile_form", partial: "form", locals: { chatbot: @chatbot, business_profile: @business_profile })
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

  def destroy
    @whatsapp_channel.destroy
    redirect_to chatbots_path, notice: "WhatsApp integration deleted successfully"
  end

  def subscribe
    @whatsapp_channel.subscribe
    redirect_to edit_chatbot_integrations_whatsapp_path(@chatbot), notice: "WhatsApp Business Profile subscribed successfully"
  rescue StandardError => e
    redirect_to edit_chatbot_integrations_whatsapp_path(@chatbot), alert: e.message
  end

  def unsubscribe
    @whatsapp_channel.unsubscribe
    redirect_to edit_chatbot_integrations_whatsapp_path(@chatbot), notice: "WhatsApp Business Profile unsubscribed successfully"
  rescue StandardError => e
    redirect_to edit_chatbot_integrations_whatsapp_path(@chatbot), alert: e.message
  end

  private

  def business_profile_params
    params.permit(:profile_picture_handle, :about, :address, :description, :email, :websites, :vertical)
  end

  def set_whatsapp_channel
    @whatsapp_channel = @chatbot.whatsapp_inbox.channel
  end

  def authorize_whatsapp_channel
    authorize @whatsapp_channel
  end
end
