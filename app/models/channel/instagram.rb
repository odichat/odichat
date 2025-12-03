class Channel::Instagram < ApplicationRecord
  include Channelable

  self.table_name = "channel_instagram"

  validates :access_token, presence: true
  validates :instagram_id, uniqueness: true, presence: true

  after_create_commit :subscribe
  before_destroy :unsubscribe

  def me
    HTTParty.get(
      "https://graph.instagram.com/v22.0/me",
      query: {
        fields: "user_id,username,name,account_type,profile_picture_url",
        access_token: access_token
      }
    )
  end

  def subscribe
    # ref https://developers.facebook.com/docs/instagram-platform/webhooks#enable-subscriptions
    HTTParty.post(
      "https://graph.instagram.com/v22.0/#{instagram_id}/subscribed_apps",
      query: {
        subscribed_fields: %w[messages message_reactions messaging_seen],
        access_token: access_token
      }
    )
  rescue StandardError => e
    Rails.logger.debug { "Rescued: #{e.inspect}" }
    true
  end

  def unsubscribe
    HTTParty.delete(
      "https://graph.instagram.com/v22.0/#{instagram_id}/subscribed_apps",
      query: {
        access_token: access_token
      }
    )
    true
  rescue StandardError => e
    Rails.logger.debug { "Rescued: #{e.inspect}" }
    true
  end

  def access_token
    Instagram::RefreshOauthTokenService.new(channel: self).access_token
  end
end
