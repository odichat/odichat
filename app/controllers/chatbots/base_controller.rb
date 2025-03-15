class Chatbots::BaseController < ApplicationController
  layout "chatbots"

  before_action :authenticate_user!
  before_action :set_chatbot

  def set_chatbot
    @chatbot = Chatbot.find(params[:id])
  end
end
