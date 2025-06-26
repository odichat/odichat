module Chatbots::ChatsHelper
  def chat_message_timestamp(message, timezone = nil)
    return "" unless message

    # Try to use the provided timezone if it's valid, otherwise use the message's own timezone
    time_in_zone =
      if timezone.present? && ActiveSupport::TimeZone[timezone]
        message.created_at.in_time_zone(timezone)
      else
        message.created_at
      end

    now_in_zone =
      if timezone.present? && ActiveSupport::TimeZone[timezone]
        Time.current.in_time_zone(timezone)
      else
        Time.current
      end

    if time_in_zone > now_in_zone - 24.hours
      time_in_zone.strftime("%H:%M")
    elsif time_in_zone > now_in_zone - 7.days
      time_in_zone.strftime("%A") # e.g., "Monday"
    else
      time_in_zone.strftime("%d/%m/%y") # e.g., "08/08/25"
    end
  end
end
