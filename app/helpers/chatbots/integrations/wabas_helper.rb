module Chatbots::Integrations::WabasHelper
  def whatsapp_card_styles
    "relative group cursor-pointer"
  end

  def whatsapp_card_gradient_styles
    "absolute -inset-1.5 bg-gradient-to-r from-[#25D366] to-[#128C7E] rounded-lg blur-md opacity-50 group-hover:opacity-75 transition duration-500"
  end

  def waba_connected?(chatbot)
    chatbot.waba.present? && chatbot.waba.access_token.present?
  end

  def is_disabled?
    if Flipper.enabled?(:paywall)
      !current_user&.payment_processor&.subscribed?
    else
      false
    end
  end
end
