class ChatbotsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chatbot, only: [ :update ]
  before_action :check_subscription, only: [ :new, :create ], unless: -> { current_user.admin? || Rails.env.development? }

  # GET /chatbots or /chatbots.json
  def index
    @chatbots = policy_scope(Chatbot)
  end

  # GET /chatbots/new
  def new
    @chatbot = Chatbot.new
    authorize @chatbot
  end

  # POST /chatbots or /chatbots.json
  def create
    @chatbot = Chatbot.new(chatbot_params)
    @chatbot.user = current_user
    authorize @chatbot

    respond_to do |format|
      if @chatbot.save
        format.html { redirect_to chatbot_playground_path(@chatbot), notice: "Chatbot was successfully created." }
        format.json { render :show, status: :created, location: @chatbot }
      else
        flash.now[:alert] = @chatbot.errors.full_messages.join(", ")
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chatbot.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @chatbot
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

  def set_chatbot
    @chatbot = Chatbot.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def chatbot_params
    params.require(:chatbot).permit(:name, :model_id, :assistant_id)
  end

  def check_subscription
    if current_user.not_subscribed_and_has_one_chatbot?
      redirect_to(
        subscriptions_pricing_path,
        alert: "You need an active subscription to create a new chatbot"
      )
    elsif (current_user.pro_plan? && current_user.chatbots.count >= 1) || (current_user.legacy_pro_plan? && current_user.chatbots.count >= 1)
      redirect_to(
        chatbots_path,
        alert: "You have reached the maximum number of chatbots for your subscription. Please contact us for a higher limit."
      )
    elsif (current_user.premium_plan? && current_user.chatbots.count >= 3) || (current_user.legacy_premium_plan? && current_user.chatbots.count >= 3)
      redirect_to(
        subscriptions_pricing_path,
        alert: "You have reached the maximum number of chatbots for your subscription. Please upgrade to a higher plan."
      )
    end
  end
end
