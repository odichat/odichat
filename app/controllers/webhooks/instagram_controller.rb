class Webhooks::InstagramController < ApplicationController
  skip_before_action :verify_authenticity_token

  def verify
    mode =      params["hub.mode"]
    token =     params["hub.verify_token"]
    challenge = params["hub.challenge"]

    if mode == "subscribe" && token == Rails.application.credentials.dig(:instagram, :webhook_verify_token)
      render json: challenge, status: :ok
    else
      render json: { error: "Invalid verification token" }, status: :unauthorized
    end
  end

  def process_payload
    Rails.logger.info("Instagram webhook received events")
    if params["object"].casecmp("instagram").zero?
      entry_params = params.to_unsafe_hash[:entry]

      if contains_echo_event?(entry_params)
        Webhooks::InstagramEventsJob.set(wait: 2.seconds).perform_later(entry_params)
      else
        Webhooks::InstagramEventsJob.perform_later(entry_params)
      end

      head :ok
    else
      Rails.logger.warn("Message is not received from the instagram webhook event: #{params['object']}")
      head :unprocessable_entity
    end
  end

  private

  def contains_echo_event?(entry_params)
    return false unless entry_params.is_a?(Array)

    entry_params.any? do |entry|
      # Check messaging array for echo events
      messaging_events = entry[:messaging] || []
      messaging_events.any? { |messaging| messaging.dig(:message, :is_echo).present? }
    end
  end
end
