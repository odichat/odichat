class ChatbotPolicy < ApplicationPolicy
  def index?
    true # Everyone can see the list of their own chatbots
  end

  def show?
    user == record.user
  end

  def create?
    true # Any authenticated user can create a chatbot
  end

  def update?
    user == record.user
  end

  def destroy?
    user == record.user
  end

  # If you have a Scope class, it ensures users only see their own chatbots in index
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
