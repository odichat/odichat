class Chatbots::SettingsController < ApplicationController
  before_action :set_chatbot

  def show
  end

  def update
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chatbot
      @chatbot = Chatbot.find(params.expect(:id))
    end
end
