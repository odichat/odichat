class ChatbotsController < ApplicationController
  before_action :authenticate_user!

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
    @chatbot.user = current_user

    respond_to do |format|
      if @chatbot.save
        format.html { redirect_to chatbots_settings_path(@chatbot), notice: "Chatbot was successfully created." }
        format.json { render :show, status: :created, location: @chatbot }
      else
        flash.now[:alert] = @chatbot.errors.full_messages.join(", ")
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
