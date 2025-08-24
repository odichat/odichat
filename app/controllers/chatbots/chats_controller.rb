class Chatbots::ChatsController < Chatbots::BaseController
  include Pagy::Backend
  before_action :set_chat, only: %i[ show intervene ]

  # GET /chats or /chats.json
  def index
    @pagy, @chats = pagy_countless(
      @chatbot.chats
        .includes(:contact)
        .joins(:messages)
        .where(source: "whatsapp")
        .select("chats.*, MAX(messages.created_at) AS last_message_at")
        .group("chats.id")
        .order("last_message_at DESC")
        .distinct,
      items: 20
    )

    @chat = @chats.first

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /chats/1 or /chats/1.json
  def show
    respond_to do |format|
      format.html { redirect_to chatbot_chats_path }
      format.turbo_stream do
        render turbo_stream:
        [
          turbo_stream.update("chat_interface_header_frame", partial: "chatbots/chats/chat_interface/main/header", locals: { chat: @chat }),
          turbo_stream.update("chat_interface_chat_messages_frame", partial: "chatbots/chats/chat_interface/main/chat", locals: { chat: @chat })
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

  def intervene
    authorize @chat
    @chat.toggle_intervention!

    respond_to do |format|
      format.html { redirect_to chatbot_chat_path(@chat.chatbot, @chat), notice: "Intervention status updated for chat with phone number #{@chat.contact.phone_number}" }
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("chat_interface_header_frame", partial: "chatbots/chats/chat_interface/main/header", locals: { chat: @chat }),
          turbo_stream.replace("chat_interface_form_frame", partial: "chatbots/chats/chat_interface/main/form", locals: { chat: @chat }),
          turbo_stream.replace("chat_list_item_#{@chat.id}", partial: "chatbots/chats/chat_interface/side/chat_list_item", locals: { chat: @chat, is_intervened: true })
        ]
      end
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def chat_params
    params.permit(:chatbot_id, :source, :contact_id, :inbox_id)
  end
end
