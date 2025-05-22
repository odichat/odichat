class Public::PlaygroundController < ApplicationController
  before_action :set_chatbot, only: [ :show ]

  def show
    @chat = @chatbot.chats.where(source: "playground").last
    @messages = @chat.messages.order(created_at: :asc)
  end

  private

  def set_chatbot
    # Raises a 404 error if the shareable link is not found
    @chatbot = ShareableLink.find_by!(token: params[:token]).chatbot
  end
end
