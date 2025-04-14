class ChatsController < ApplicationController
  before_action :set_chat, only: %i[ show ]

  # GET /chats or /chats.json
  def index
    @chats = Chat.all
  end

  # GET /chats/1 or /chats/1.json
  def show
  end

  def create
    @chat = Chat.new(chat_params)

    respond_to do |format|
      if @chat.save
        format.html { redirect_to chatbot_playground_path(@chat.chatbot), notice: "Chat was successfully created." }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("chat", partial: "chatbots/playground/chat", locals: { chat: @chat, messages: @chat.messages || [], chatbot: @chat.chatbot })
        }
      else
        format.html { redirect_to chatbot_playground_path(@chat.chatbot), status: :unprocessable_entity, alert: @chat.errors.full_messages.join(", ") }
        format.turbo_stream {
          flash.now[:alert] = @chat.errors.full_messages.to_sentence
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        }
      end
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def chat_params
    params.require(:chat).permit(:chatbot_id, :source)
  end
end
