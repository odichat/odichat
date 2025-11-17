class LeadWebhookNotificationJob < ApplicationJob
  queue_as :default

  class DeliveryFailedError < StandardError; end

  retry_on DeliveryFailedError, wait: :exponentially_longer, attempts: 5

  def perform(lead_id)
    lead = Lead.find_by(id: lead_id)

    unless lead.present?
      Rails.logger.warn("LeadWebhookNotificationJob aborted: lead #{lead_id} not found")
      return
    end

    response = HTTParty.post(
      webhook_url,
      body: payload_for(lead).to_json,
      headers: { "Content-Type" => "application/json" },
      timeout: 5
    )

    if response.success?
      Rails.logger.info("LeadWebhookNotificationJob succeeded for lead #{lead_id} (status #{response.code})")
    else
      Rails.logger.error("LeadWebhookNotificationJob failed for lead #{lead_id} status=#{response.code} body=#{response.body}")
      raise DeliveryFailedError, "Webhook failed with status #{response.code}"
    end
  rescue Net::OpenTimeout, Net::ReadTimeout => e
    Rails.logger.error("LeadWebhookNotificationJob timeout for lead #{lead_id}: #{e.message}")
    raise DeliveryFailedError, e.message
  end

  private

    def webhook_url
      "https://primary-production-e0185.up.railway.app/webhook/d6bc1766-f002-4570-8ec1-f18cacba5ca7"
    end

    def payload_for(lead)
      {
        lead: {
          name: lead.name,
          phone_number: lead.phone_number,
          trigger: lead.trigger,
          created_at: lead.created_at
        }
      }
    end
end
