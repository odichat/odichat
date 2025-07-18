class Chatbots::PlaygroundController < Chatbots::BaseController
  before_action :set_models, only: [ :show ]
  before_action :set_public_url, only: [ :show ]

  def show
    @chat = @chatbot.chats.where(source: "playground").last
    @chat = @chatbot.chats.create!(source: "playground") if @chat.nil?
    @messages = @chat.messages.order(created_at: :asc)
  end

  def update
    if @chatbot.update(chatbot_params)
      respond_to do |format|
        format.html { redirect_to chatbot_playground_path(@chatbot), notice: "Chatbot was successfully updated." }
        format.turbo_stream {
          flash.now[:notice] = "Chatbot was successfully updated."
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to chatbot_playground_path(@chatbot), alert: "Chatbot was not updated." }
        format.turbo_stream {
          flash.now[:alert] = @chatbot.errors.full_messages.to_sentence
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        }
      end
    end
  end

  private

  def chatbot_params
    params.require(:chatbot).permit(:name, :model_id, :temperature, :system_instructions)
  end

  def set_models
    if Rails.env.production?
      if !current_user.subscribed?
        @models = Model.where(name: "gpt-4o-mini")
      elsif current_user.basic_plan?
        @models = Model.where(name: [ "gpt-4o-mini", "gpt-4o", "o4-mini" ])
      elsif current_user.pro_plan?
        @models = Model.all
      end
    else
      @models = Model.all
    end
  end

  def set_public_url
    @public_url = @chatbot.public_url
  end
end
