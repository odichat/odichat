module Chatbots::ChatsHelper
  def last_message_timestamp(timestamp, timezone = nil)
    return "" unless timestamp.present?

    # Try to use the provided timezone if it's valid, otherwise use the message's own timezone
    time_in_zone =
      if timezone.present? && ActiveSupport::TimeZone[timezone]
        timestamp.in_time_zone(timezone)
      else
        timestamp
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
