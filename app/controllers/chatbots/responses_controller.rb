class Chatbots::ResponsesController < Chatbots::BaseController
  include Pagy::Backend
  before_action :set_response, only: %i[ destroy ]

  def index
    @pagy, @responses = pagy_countless(
      @chatbot.responses.order(created_at: :desc),
      limit: 10
    )

    @response = @chatbot.responses.build
    @is_processing_documents = @chatbot.documents.pending.any?

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
    @response = @chatbot.responses.build(response_params)

    respond_to do |format|
      if @response.save
        format.html { redirect_to chatbot_responses_path(@chatbot), notice: "FAQ was successfully created." }
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
        if params[:redirect].present?
          redirect_to params[:redirect],
              notice: "FAQ successfully deleted.",
              status: :see_other
        else
          flash.now[:notice] = "FAQ successfuly deleted."
          render turbo_stream: [
            turbo_stream.remove(@response),
            turbo_stream.update("flash", partial: "shared/flash_messages")
          ]
        end
      end
    end
  end

  private

    def response_params
      params.require(:response).permit(:question, :answer)
    end

    def set_response
      @response = @chatbot.responses.find(params[:id])
    end
end
