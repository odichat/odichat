class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # Only return messages from chats belonging to the user's chatbots
      scope.includes(chat: :chatbot).where(chatbots: { user_id: user.id })
    end
  end

  def index?
    user.present?
  end

  def show?
    user_owns_message?
  end

  def create?
    user_owns_message?
  end

  def update?
    user_owns_message?
  end

  def destroy?
    user_owns_message?
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  private

  def user_owns_message?
    record.chat&.chatbot&.user_id == user.id
  end
end
