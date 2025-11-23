module Chatbots::LeadsHelper
  def lead_created_at(lead)
    return "-" unless lead&.created_at

    lead.created_at
        .in_time_zone(Time.zone)
        .strftime("%b %e, %Y %l:%M %p %Z")
  end
end
