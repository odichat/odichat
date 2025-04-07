class Waba < ApplicationRecord
  include WhatsappClient

  belongs_to :chatbot

  def self.available_verticals
    {
      "ALCOHOL" => "Alcoholic Beverages",
      "APPAREL" => "Clothing and Apparel",
      "AUTO" => "Automotive",
      "BEAUTY" => "Beauty, Spa and Salon",
      "EDU" => "Education",
      "ENTERTAIN" => "Entertainment",
      "EVENT_PLAN" => "Event Planning and Service",
      "FINANCE" => "Finance and Banking",
      "GOVT" => "Public Service",
      "GROCERY" => "Food and Grocery",
      "HEALTH" => "Medical and Health",
      "HOTEL" => "Hotel and Lodging",
      "NONPROFIT" => "Non-profit",
      "ONLINE_GAMBLING" => "Online Gambling & Gaming",
      "OTC_DRUGS" => "Over-the-Counter Drugs",
      "OTHER" => "Other",
      "PHYSICAL_GAMBLING" => "Non-Online Gambling & Gaming (E.g. Brick and mortar)",
      "PROF_SERVICES" => "Professional Services",
      "RESTAURANT" => "Restaurant",
      "RETAIL" => "Shopping and Retail",
      "TRAVEL" => "Travel and Transportation"
    }
  end

  def get_business_profile
    client = whatsapp_client(self.access_token)
    client.business_profiles.get(self.phone_number_id)
  end

  def update_business_profile(params)
    client = whatsapp_client(self.access_token)
    if params[:websites].present?
      params[:websites] = params[:websites].split(",").map(&:strip)
    end
    # business_profiles.update responds with Boolean
    client.business_profiles.update(
      phone_number_id: self.phone_number_id,
      params: params
    )
  end

  def get_connected_phone_number
    client = whatsapp_client(self.access_token)
    client.phone_numbers.get(self.phone_number_id)
  end
end
