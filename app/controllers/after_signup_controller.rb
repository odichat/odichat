class AfterSignupController < ApplicationController
  layout "onboarding"
  include Wicked::Wizard

  before_action :authenticate_user!

  steps :create_chatbot, :create_faqs, :create_products, :test_playground, :connect_whatsapp

  def show
    @user = current_user

    case step
    when :create_chatbot
      @chatbot = @user.chatbots.build
    when :create_faqs
    when :create_products
    when :test_playground
    when :connect_whatsapp
    end

    render_wizard
  end

  def update
    @user = current_user

    case step
    when :create_chatbot
      @chatbot = build_chatbot_for(@user)
      render_wizard(@chatbot)
    else
      render_wizard @user
    end
  end

  private

  def build_chatbot_for(user)
    chatbot = user.chatbots.build(chatbot_params)
    chatbot.save
    chatbot
  end

  def chatbot_params
    params.require(:chatbot).permit(:name)
  end
end
