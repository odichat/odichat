class ChatbotsController < ApplicationController
  before_action :authenticate_user!

  # GET /chatbots or /chatbots.json
  def index
    @chatbots = current_user.chatbots
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
        format.html { redirect_to chatbot_settings_path(@chatbot), notice: "Chatbot was successfully created." }
        format.json { render :show, status: :created, location: @chatbot }
      else
        flash.now[:alert] = @chatbot.errors.full_messages.join(", ")
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chatbot.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @chatbot = Chatbot.find(params[:id])

    respond_to do |format|
      if @chatbot.update(chatbot_params)
        format.html { redirect_to chatbot_playground_path(@chatbot), notice: "Chatbot was successfully updated." }
        format.turbo_stream {
          flash.now[:notice] = "Chatbot was successfully updated."
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        }
      else
        format.html { redirect_to chatbot_playground_path(@chatbot), alert: @chatbot.errors.full_messages.join(", ") }
        format.turbo_stream {
          flash.now[:alert] = @chatbot.errors.full_messages.join(", ")
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        }
      end
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def chatbot_params
      params.require(:chatbot).permit(:name, :model_id, :assistant_id)
    end
end
