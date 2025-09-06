module Chatbots::SettingsHelper
  def timezone_options_for_select
    ::Chatbot.timezone_options.to_a
  end
end
