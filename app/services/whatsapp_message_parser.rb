class WhatsappMessageParser
  def initialize(payload)
    @payload = payload
  end

  def message_type
    @payload.dig("entry", 0, "changes", 0, "value", "messages", 0, "type")
  end

  def extract_message_data
    case message_type
    when "text"
      extract_text_message_data
    when "image"
      extract_image_message_data
    else
      nil
    end
  end

  private

  def extract_text_message_data
    value =   @payload.dig("entry", 0, "changes", 0, "value")
    waba_id = @payload.dig("entry", 0, "id")
    message = value.dig("messages", 0)
    contact = value.dig("contacts", 0)

    {
      waba_id:      waba_id,
      from_phone_number:        message["from"],
      name:         contact.dig("profile", "name"),
      message_text: message.dig("text", "body"),
    }
  end

  def extract_image_message_data
    value =   @payload.dig("entry", 0, "changes", 0, "value")
    waba_id = @payload.dig("entry", 0, "id")
    message = value.dig("messages", 0)
    contact = value.dig("contacts", 0)

    {
      waba_id:      waba_id,
      from_phone_number:        message["from"],
      name:      contact.dig("profile", "name"),
      caption:   message.dig("image", "caption"),
      image_id:  message.dig("image", "id"),
      mime_type: message.dig("image", "mime_type"),
      sha256:    message.dig("image", "sha256")
    }
  end
end
