class ChatsController < ApplicationController
  before_action :set_chat, only: %i[ show ]

  # GET /chats or /chats.json
  def index
    @chats = Chat.all
  end

  # GET /chats/1 or /chats/1.json
  def show
  end

  private

  def set_chat
    @chat = Chat.find(params.expect(:id))
  end
end
