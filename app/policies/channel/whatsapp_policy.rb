class Channel::WhatsappPolicy < ApplicationPolicy
  def update?
    record.chatbot.user == user
  end

  def destroy?
    record.chatbot.user == user
  end

  def subscribe?
    record.chatbot.user == user
  end

  def unsubscribe?
    record.chatbot.user == user
  end
end
