class Chatbots::LeadsController < Chatbots::BaseController
  include Pagy::Backend
  before_action :set_lead, only: %i[destroy edit update]

  def index
    @pagy, @leads = pagy(
      @chatbot.leads.order(created_at: :asc),
      limit: 20
    )
  end

  def new
  end

  def create
    @lead = @chatbot.leads.build(lead_params)

    respond_to do |format|
      if @lead.save
        format.html { redirect_to chatbot_leads_path(@chatbot), notice: "Lead was successfully created." }
      else
        format.html { redirect_to chatbot_leads_path(@chatbot), alert: "Lead could not be created"  }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @lead.update(lead_params)
        format.html { redirect_to chatbot_leads_path(@chatbot), notice: "Lead was successfully updated." }
      else
        format.html { redirect_to chatbot_leads_path(@chatbot), alert: "Lead could not be updated." }
      end
    end
  end

  def destroy
    return unless @lead

    if @lead.destroy
      respond_to do |format|
        format.html { redirect_to chatbot_leads_path(@chatbot), notice: "Lead successfuly deleted." }
      end
    else
      respond_to do |format|
        format.html { redirect_to chatbot_leads_path(@chatbot), alert: "Lead could not be deleted" }
      end
    end
  end

  private

    def lead_params
      params.require(:lead).permit(:chatbot_id, :contact_id, :trigger)
    end

    def set_lead
      @lead = @chatbot.leads.find(params[:id])
    end
end
