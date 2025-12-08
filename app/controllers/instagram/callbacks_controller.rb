class Instagram::CallbacksController < ApplicationController
  include InstagramConcern

  def show
    if params[:error].present?
      handle_authorization_error
      return
    end

    process_successful_authorization
  rescue StandardError => e
    handle_error(e)
  end

  private

  def process_successful_authorization
    Rails.logger.info("[InstagramConnect] Starting OAuth code exchange for chatbot #{chatbot_id}")

    @response = instagram_client.auth_code.get_token(
      oauth_code,
      redirect_uri: "#{base_url}/#{provider_name}/callback",
      grant_type: "authorization_code"
    )

    Rails.logger.info("[InstagramConnect] Short-lived token retrieved via https://api.instagram.com/oauth/access_token")

    @long_lived_token_response = exchange_for_long_lived_token(@response.token)
    Rails.logger.info("[InstagramConnect] Long-lived token requested via https://graph.instagram.com/access_token")

    _inbox, already_exists = find_or_create_inbox

    if already_exists
      redirect_to chatbot_integrations_path(chatbot_id)
    else
      redirect_to chatbot_integrations_path(chatbot_id)
    end
  end

  def find_or_create_inbox
    user_details = fetch_instagram_user_details(@long_lived_token_response["access_token"])
    Rails.logger.info("[InstagramConnect] Instagram user lookup via https://graph.instagram.com/v22.0/me returned #{user_details['username']} (#{user_details['user_id']})")

    channel_instagram = find_channel_by_instagram_id(user_details["user_id"].to_s)
    channel_exists = channel_instagram.present?

    if channel_instagram
      update_channel(channel_instagram, user_details)
    else
      channel_instagram = create_channel_with_inbox(user_details)
    end

    # reauthorize channel, this code path only triggers when instagram auth is successful
    # reauthorized will also update cache keys for the associated inbox
    # channel_instagram.reauthorized!

    [ channel_instagram.inbox, channel_exists ]
  end

  def update_channel(channel_instagram, user_details)
    expires_at = Time.current + @long_lived_token_response["expires_in"].seconds

    channel_instagram.update!(
      access_token: @long_lived_token_response["access_token"],
      expires_at: expires_at
    )

    # Update inbox name if username changed
    # channel_instagram.inbox.update!(name: user_details["username"])
    channel_instagram
  end

  def create_channel_with_inbox(user_details)
    ActiveRecord::Base.transaction do
      expires_at = Time.current + @long_lived_token_response["expires_in"].seconds

      channel_instagram = Channel::Instagram.create!(
        chatbot: chatbot,
        access_token: @long_lived_token_response["access_token"],
        instagram_id: user_details["user_id"].to_s,
        expires_at: expires_at
      )

      chatbot.inboxes.create!(
        channel: channel_instagram
      )

      channel_instagram
    end
  end

  def chatbot
    @chatbot ||= Chatbot.find(chatbot_id)
  end

  def chatbot_id
    puts "*********************"
    puts params[:state]
    puts "*********************"
    params[:state]
  end

  def find_channel_by_instagram_id(instagram_id)
    Channel::Instagram.find_by(instagram_id: instagram_id)
  end

  def handle_error(error)
    Rails.logger.error("Instagram Channel creation Error: #{error.message}")
    puts "Instagram Channel creation Error: #{error.message}"
    respond_with_error(500, error)
  end

  def oauth_code
    params[:code]
  end

  def provider_name
    "instagram"
  end
end
