class Chatbots::ChatsController < Chatbots::BaseController
  before_action :set_chat, only: %i[ show ]

  # GET /chats or /chats.json
  def index
    @chats = @chatbot.chats
      .joins(:messages)
      .where(source: "whatsapp")
      .select("chats.*, MAX(messages.created_at) AS last_message_at")
      .group("chats.id")
      .order("MAX(messages.created_at) DESC")
      .limit(20)
    @chat = @chats.first
  end

  # GET /chats/1 or /chats/1.json
  def show
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream:
        [
          turbo_stream.update("chat_messages", partial: "chatbots/chats/chat", locals: { chat: @chat }),
          turbo_stream.update("chat_details", partial: "chatbots/chats/chat_header_info", locals: { chat: @chat })
        ]
      end
    end
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
    params.permit(:chatbot_id, :source)
  end
end
