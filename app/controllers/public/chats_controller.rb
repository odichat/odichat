class Public::ChatsController < ApplicationController
  def create
    @chat = Chat.new(chat_params)

    respond_to do |format|
      if @chat.save
        # Ensure session structure exists
        session[:public_chatbot_chats] ||= {}
        # Store the new chat_id in the session for the current chatbot
        session[:public_chatbot_chats][@chat.chatbot_id.to_s] = @chat.id

        format.html { redirect_to chatbot_playground_path(@chat.chatbot), notice: "Chat was successfully created." }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("public-chat", partial: "public/playground/chat", locals: { chat: @chat, messages: @chat.messages || [], chatbot: @chat.chatbot })
        }
      else
        format.html { redirect_to chatbot_playground_path(@chat.chatbot || Chatbot.find(chat_params[:chatbot_id])), status: :unprocessable_entity, alert: @chat.errors.full_messages.join(", ") }
        format.turbo_stream {
          flash.now[:alert] = @chat.errors.full_messages.to_sentence
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        }
      end
    end
  end

  def chat_params
    params.require(:chat).permit(:chatbot_id, :source, :contact_id, :inbox_id)
  end
end
