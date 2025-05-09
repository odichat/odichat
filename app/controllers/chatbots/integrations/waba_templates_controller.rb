class Chatbots::Integrations::WabaTemplatesController < Chatbots::BaseController
  before_action :set_waba
  skip_before_action :authorize_chatbot, only: [ :index, :destroy_message_template ]

  def index
    @templates = @waba.message_templates.records
  end

  def destroy_message_template
    respond_to do |format|
      if @waba.delete_message_template(params[:waba_template_id])
        format.html { redirect_to chatbot_integrations_waba_templates_path(@chatbot), notice: "Template deleted successfully" }
      else
        format.html { redirect_to chatbot_integrations_waba_templates_path(@chatbot), alert: "Template deletion failed" }
      end
    end
  end

  private

  def set_waba
    @waba = @chatbot.waba
  end
end
