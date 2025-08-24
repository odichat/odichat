class Public::PlaygroundController < ApplicationController
  before_action :set_chatbot, only: [ :show ]

  def show
    # Initialize session for chatbots if it doesn't exist
    session[:public_chatbot_chats] ||= {}

    chat_id_for_chatbot = session[:public_chatbot_chats][@chatbot.id.to_s]

    if chat_id_for_chatbot
      @chat = @chatbot.chats.where(source: "public_playground").find_by(id: chat_id_for_chatbot)
    end

    @chat ||= @chatbot.last_public_playground_chat

    if @chat.nil?
      @chatbot.send(:create_public_playground_resources)
      @chat = @chatbot.last_public_playground_chat

      # Safety check
      unless @chat
        redirect_to root_path, alert: "Unable to access playground"
        return
      end
    end

    session[:public_chatbot_chats][@chatbot.id.to_s] = @chat.id
    @messages = @chat.messages.order(created_at: :asc)
  end

  private

  def set_chatbot
    # Raises a 404 error if the shareable link is not found
    @chatbot = ShareableLink.find_by!(token: params[:token]).chatbot
  end
end
