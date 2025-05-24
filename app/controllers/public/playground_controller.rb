class Public::PlaygroundController < ApplicationController
  before_action :set_chatbot, only: [ :show ]

  def show
    # Initialize session for chatbots if it doesn't exist
    session[:public_chatbot_chats] ||= {}

    chat_id_for_chatbot = session[:public_chatbot_chats][@chatbot.id.to_s]

    if chat_id_for_chatbot
      @chat = @chatbot.chats.where(source: "public_playground").find_by(id: chat_id_for_chatbot)
    end

    # If chat is not found (e.g., ID from an old session or chat was deleted) or doesn't exist
    unless @chat
      @chat = @chatbot.chats.create(source: "public_playground")
      session[:public_chatbot_chats][@chatbot.id.to_s] = @chat.id
    end

    @messages = @chat.messages.order(created_at: :asc)
  end

  private

  def set_chatbot
    # Raises a 404 error if the shareable link is not found
    @chatbot = ShareableLink.find_by!(token: params[:token]).chatbot
  end
end
