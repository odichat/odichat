class ChatbotsController < ApplicationController
  # GET /chatbots or /chatbots.json
  def index
    @chatbots = Chatbot.all
  end

  # GET /chatbots/new
  def new
    @chatbot = Chatbot.new
  end

  # POST /chatbots or /chatbots.json
  def create
    @chatbot = Chatbot.new(chatbot_params)

    respond_to do |format|
      if @chatbot.save
        format.html { redirect_to @chatbot, notice: "Chatbot was successfully created." }
        format.json { render :show, status: :created, location: @chatbot }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chatbot.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def chatbot_params
      params.require(:chatbot).permit(:name)
    end
end
