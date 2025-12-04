module Chatbots::ConversationsHelper
  WHATSAPP_ICON_URL = "https://conversalo.nyc3.cdn.digitaloceanspaces.com/wa.svg".freeze
  INSTAGRAM_ICON_URL = "https://conversalo.nyc3.cdn.digitaloceanspaces.com/ig.svg".freeze

  def conversation_display_name(conversation)
    contact = conversation.contact
    contact_name = contact&.name.presence
    contact_phone = contact&.phone_number.presence

    display_name =
      if conversation.instagram?
        contact_name || "Instagram user"
      else
        contact_name || (contact_phone ? "+#{contact_phone}" : nil)
      end

    display_name || "Unknown contact"
  end

  def conversation_platform_badge(conversation)
    metadata = platform_metadata(conversation)
    return unless metadata

    content_tag(:span, class: metadata[:class], title: metadata[:title]) do
      image_tag metadata[:icon_url], alt: metadata[:alt], class: "size-4 object-contain"
    end
  end

  def conversation_contact_identifier(conversation)
    contact = conversation&.contact
    return "" unless contact

    if conversation.instagram?
      username = contact.additional_attributes.to_h.with_indifferent_access[:social_instagram_user_name].presence
      return normalize_instagram_username(username) if username
    end

    phone = contact.phone_number.to_s.presence
    phone ? "+#{phone}" : ""
  end

  private

  def normalize_instagram_username(username)
    username.start_with?("@") ? username : "@#{username}"
  end

  def platform_metadata(conversation)
    if conversation.whatsapp?
      {
        icon_url: WHATSAPP_ICON_URL,
        class: "text-success",
        title: "WhatsApp conversation",
        alt: "WhatsApp logo"
      }
    elsif conversation.instagram?
      {
        icon_url: INSTAGRAM_ICON_URL,
        class: "text-pink-500",
        title: "Instagram conversation",
        alt: "Instagram logo"
      }
    end
  end
end
