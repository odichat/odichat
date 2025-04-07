class Waba < ApplicationRecord
  include WhatsappClient

  belongs_to :chatbot

  def get_business_profile
    client = whatsapp_client(self.access_token)
    client.business_profiles.get(self.phone_number_id)
  end

  def update_business_profile(params)
    client = whatsapp_client(self.access_token)
    # business_profiles.update responds with Boolean
    client.business_profiles.update(phone_number_id: self.phone_number_id, params: params)
  end

  def get_connected_phone_number
    client = whatsapp_client(self.access_token)
    client.phone_numbers.get(self.phone_number_id)
  end
end
