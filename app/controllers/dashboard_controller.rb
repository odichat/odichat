class DashboardController < ApplicationController
  def index
    @chatbots = Chatbot.all
  end
end
