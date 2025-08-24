class WhatsappChannelPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # Only return whatsapp channels from chatbots belonging to the user
      scope.includes(chatbot: :user).where(chatbots: { user_id: user.id })
    end
  end

  def index?
    user.present?
  end

  def show?
    user_owns_whatsapp_channel?
  end

  def create?
    user_owns_whatsapp_channel?
  end

  def update?
    user_owns_whatsapp_channel?
  end

  def destroy?
    user_owns_whatsapp_channel?
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  def subscribe?
    user_owns_whatsapp_channel?
  end

  def unsubscribe?
    user_owns_whatsapp_channel?
  end

  private

  def user_owns_whatsapp_channel?
    record.chatbot&.user_id == user.id
  end
end
