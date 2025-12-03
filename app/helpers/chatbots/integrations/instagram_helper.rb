module Chatbots::Integrations::InstagramHelper
  def instagram_card_styles
    "relative group cursor-pointer"
  end

  def instagram_card_gradient_styles
    "absolute -inset-1.5 bg-gradient-to-r from-[#F58529] via-[#DD2A7B] to-[#515BD4] rounded-lg blur-md opacity-50 group-hover:opacity-75 transition duration-500"
  end

  def instagram_background_styles
    "absolute inset-0 bg-radial-[at_25%_25%] from-[#F58529]/20 via-[#FEDA77]/40 to-[#515BD4]/30 rounded-lg animate-[pulse_4s_ease-in-out_infinite] opacity-70"
  end

  def instagram_connected?(chatbot)
    instagram_channel = Channel::Instagram.find_by(chatbot_id: chatbot.id)
    instagram_channel.present? && instagram_channel.access_token.present?
  end
end
