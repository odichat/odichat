class Channel::InstagramPolicy < ApplicationPolicy
  def show?
    record.chatbot.user == user
  end

  def destroy?
    show?
  end
end
