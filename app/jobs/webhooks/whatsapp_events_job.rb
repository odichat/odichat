class Webhooks::WhatsappEventsJob < ApplicationJob
  queue_as :default

  def perform(params = {})
    Whatsapp::IncomingMessageWhatsappCloudService.new(params: params).perform
  end
end
