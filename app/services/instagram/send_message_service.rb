class Instagram::SendMessageService

  def initialize(message:)
    @message = message
    @chat = @message.chat
    @inbox = @chat.inbox
    @contact = @chat.contact
    @channel = @inbox.channel
  end

  def send_message
    return unless outgoing_message?
    return if invalid_message?

    message_content = message_params
    access_token = @channel.access_token
    query = { access_token: access_token }
    instagram_id = @channel.instagram_id.presence || "me"

    response = HTTParty.post(
      "https://graph.instagram.com/v22.0/#{instagram_id}/messages",
      body: message_content,
      query: query
    )

    process_response(response, message_content)
  end

  private

  def invalid_message?
    # private notes aren't send to the channels
    # we should also avoid the case of message loops, when outgoing messages are created from channel
    @message.source_id.present?
  end

  def outgoing_message?
    @message.assistant?
  end

  def message_params
    params = {
      recipient: { id: @contact.get_source_id(@inbox.id) },
      message: {
        text: @message.content
      }
    }

    # merge_human_agent_tag(params)
  end

  def process_response(response, message_content)
    parsed_response = response.parsed_response
    if response.success? && parsed_response["error"].blank?
      @message.update!(source_id: provider_message_id(parsed_response))
      parsed_response
    else
      external_error = external_error(parsed_response)
      Rails.logger.error("Instagram response: #{external_error} : #{message_content}")
      # Messages::StatusUpdateService.new(message, 'failed', external_error).perform
      nil
    end
  end

  def external_error(response)
    error_message = response.dig("error", "message")
    error_code = response.dig("error", "code")

    # https://developers.facebook.com/docs/messenger-platform/error-codes
    # Access token has expired or become invalid. This may be due to a password change,
    # removal of the connected app from Instagram account settings, or other reasons.
    # channel.authorization_error! if error_code == 190

    "#{error_code} - #{error_message}"
  end

  def provider_message_id(parsed_response)
    parsed_response["id"].presence || parsed_response["message_id"]
  end
end
