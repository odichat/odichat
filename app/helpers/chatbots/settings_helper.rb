module Chatbots::SettingsHelper
  def timezone_options_for_select
    desired_iana_timezones = [
      "America/Chicago",         # Central Time (US)
      "America/Mexico_City",     # Mexico City
      "America/Monterrey",       # Monterrey
      "America/Bogota",          # Bogota
      "America/Argentina/Buenos_Aires", # Buenos Aires
      "America/Montevideo",      # Montevideo
      "America/Caracas",         # Caracas
      "America/Lima",            # Lima
      "America/Guayaquil"        # Quito (Ecuador mainland time)
    ]

    desired_iana_timezones.map do |iana_name|
      tz = ActiveSupport::TimeZone[iana_name]
      if tz
        # tz.to_s will give a string like "(GMT-05:00) Central Time (US & Canada)"
        [ tz.to_s, iana_name ]
      else
        # Fallback in case an IANA name is not recognized
        [ iana_name, iana_name ]
      end
    end.sort_by(&:first) # Sort by the display name
  end
end
