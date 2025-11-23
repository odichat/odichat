class Lead < ApplicationRecord
  belongs_to :chatbot
  belongs_to :contact

  delegate :name, :phone_number, to: :contact

  # after_create_commit :send_webhook_notification

  private

    # def send_webhook_notification
    #   # If chatbot.user.email is andres@odichat.app send webhook to https://webhook.site/xxxxxx for testing
    #   return unless chatbot.user.email == "andres@odichat.app"
    #   LeadWebhookNotificationJob.perform_later(self.id)
    # end
end
