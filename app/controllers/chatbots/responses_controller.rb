class Chatbots::ResponsesController < Chatbots::BaseController
  include Pagy::Backend
  before_action :set_faq_agent
  before_action :set_response, only: %i[ destroy ]

  def index
    @pagy, @responses = pagy_countless(
      @faq_agent.responses.order(created_at: :desc),
      limit: 10
    )

    @response = @faq_agent.responses.build
    @processing_documents = @chatbot.documents.pending

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
  end

  def new
  end

  def create
    @response = @faq_agent.responses.build(response_params)

    respond_to do |format|
      if @response.save
        format.html { redirect_to chatbot_responses_path(@chatbot), notice: "Chatbot response was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @response.destroy

    respond_to do |format|
      format.html { redirect_to chatbot_responses_path(@chatbot), notice: "FAQ successfuly deleted." }
      format.turbo_stream do
        flash.now[:notice] = "FAQ successfuly deleted."

        render turbo_stream: [
          turbo_stream.remove(@response),
          turbo_stream.update("flash", partial: "shared/flash_messages")
        ]
      end
    end
  end

  private

    def set_faq_agent
      @faq_agent = Roleable::Faq.find_by(chatbot_id: @chatbot.id)

      return if @faq_agent.present?

      respond_to do |format|
        format.html { redirect_to chatbot_path(@chatbot), alert: "FAQ agent not found" }
        format.turbo_stream do
          flash.now[:alert] = "FAQ agent not found"
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        end
      end
    end

    def response_params
      params.require(:response).permit(:question, :answer)
    end

    def set_response
      @response = @faq_agent.responses.find(params[:id])
    end
end
