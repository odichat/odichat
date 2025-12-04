class Chatbots::Integrations::InstagramController < Chatbots::BaseController
  before_action :set_instagram_channel, only: [ :show, :destroy ]
  before_action :authorize_instagram_channel, only: [ :show, :destroy ]

  def show
    @me = @instagram_channel.me
  end

  def destroy
    @instagram_channel.destroy!
    redirect_to chatbot_integrations_path(@chatbot), notice: "Instagram account disconnected."
  rescue StandardError => e
    Rails.logger.error("Instagram disconnect failed: #{e.message}")
    redirect_to chatbot_integrations_instagram_path(@chatbot), alert: "Unable to disconnect Instagram right now."
  end

  private

  def set_instagram_channel
    @instagram_channel = @chatbot.instagram_inbox&.channel
    raise ActiveRecord::RecordNotFound if @instagram_channel.nil?
  end

  def authorize_instagram_channel
    authorize @instagram_channel
  end
end
