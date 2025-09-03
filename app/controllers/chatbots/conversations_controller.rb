class Chatbots::ConversationsController < Chatbots::BaseController
  include Pagy::Backend
  before_action :set_conversation, only: [ :show, :intervene ]

  def index
    @pagy, @conversations = pagy_countless(
      @chatbot.conversations.includes(:contact).ordered_by_latest,
      items: 20
    )

    @conversation = @conversations.first

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @contact = @conversation.contact
    @messages = Message.joins(:chat).where(chats: { chatbot_id: @chatbot.id, contact_id: @contact.id }).order(created_at: :asc)

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream:
        [
          turbo_stream.update("chat_interface_header_frame", partial: "chatbots/conversations/main/header", locals: { conversation: @conversation, messages: @messages }),
          turbo_stream.update("chat_interface_conversation_messages_frame", partial: "chatbots/conversations/main/conversation", locals: { conversation: @conversation, messages: @messages })
        ]
      end
    end
  end

  def intervene
    # authorize @conversation
    @conversation.toggle_intervention!

    respond_to do |format|
      format.html { redirect_to chatbot_conversation_path(@conversation.chatbot, @conversation), notice: "Intervention status updated for chat with phone number #{@conversation.contact.phone_number}" }
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("chat_interface_header_frame", partial: "chatbots/conversations/main/header", locals: { conversation: @conversation }),
          turbo_stream.replace("chat_interface_#{@conversation.id}_form_frame", partial: "chatbots/conversations/main/form", locals: { conversation: @conversation }),
          turbo_stream.replace("conversation_item_#{@conversation.id}", partial: "chatbots/conversations/list/conversation_item", locals: { conversation: @conversation })
        ]
      end
    end
  end

  private

  def set_conversation
    @conversation = Conversation.includes(:contact).find(params[:id])
    return if @conversation.present?
    redirect_to chatbot_conversations_path(@chatbot), alert: "Conversation not found." and return
  end
end
