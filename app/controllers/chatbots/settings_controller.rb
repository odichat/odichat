class Chatbots::SettingsController < Chatbots::BaseController
  before_action :set_chatbot

  def show
  end

  def update
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chatbot
      @chatbot = Chatbot.find(params[:id])
    end
end
