class Chatbots::ResponsesController < Chatbots::BaseController
  include Pagy::Backend

  def index
    @pagy, @responses = pagy_countless(
      @chatbot.responses.order(created_at: :desc),
      items: 10
    )

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
  end

  private

    def response_params
      params.require(:response).permit(:question, :answer)
    end
end
