module Chatbots::ChatsHelper
  def chat_message_timestamp(message)
    return "" unless message

    if message.created_at > 24.hours.ago
      message.created_at.strftime("%H:%M")
    elsif message.created_at > 7.days.ago
      message.created_at.strftime("%A") # e.g., "Monday"
    else
      message.created_at.strftime("%d/%m/%y") # e.g., "08/08/25"
    end
  end
end
