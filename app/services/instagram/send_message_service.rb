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
    endpoint = "https://graph.instagram.com/v22.0/#{instagram_id}/messages"

    log_instagram_message_request(endpoint, message_content, query)

    response = HTTParty.post(
      endpoint,
      body: message_content,
      query: query
    )

    log_instagram_message_response(endpoint, response)

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

  def log_instagram_message_request(endpoint, message_content, query)
    Rails.logger.info(
      "[InstagramConnect] Sending Instagram message via #{endpoint} "\
      "with payload #{message_content} and query #{filter_sensitive_params(query)}"
    )
  end

  def log_instagram_message_response(endpoint, response)
    Rails.logger.info(
      "[InstagramConnect] Response from #{endpoint} status=#{response.code} body=#{response.body}"
    )
  end

  def filter_sensitive_params(params)
    params.each_with_object({}) do |(key, value), filtered|
      if key.to_s.match?(/token|secret|code/i)
        filtered[key] = "[FILTERED]"
      else
        filtered[key] = value
      end
    end
  end
end
