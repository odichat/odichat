class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    mode =      params["hub.mode"]
    token =     params["hub.verify_token"]
    challenge = params["hub.challenge"]

    if mode == "subscribe" && token == ENV["WEBHOOK_VERIFY_TOKEN"]
      render json: challenge, status: :ok
    else
      render json: { error: "Invalid verification token" }, status: :unauthorized
    end
  end


  def create
  end
end
