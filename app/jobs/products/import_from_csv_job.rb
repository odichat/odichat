require "csv"

class Products::ImportFromCsvJob < ApplicationJob
  include Rails.application.routes.url_helpers
  queue_as :default

  def perform(file_path, chatbot_id, refresh_path = nil)
    @file = File.open(file_path)
    @chatbot = Chatbot.find(chatbot_id)

    return unless @chatbot.present? || @file.present?

    created_count = @chatbot.products.import_from_csv(@file, @chatbot.id)

    File.delete(file_path) if File.exist?(file_path)

    refresh_path ||= chatbot_products_path(@chatbot)

    Turbo::StreamsChannel.broadcast_replace_to(
      [ @chatbot, :products ],
      target: "products-table",
      html: ApplicationController.render(
        inline: "<%= turbo_frame_tag 'products-table', src: url %>",
        locals: { url: refresh_path }
      )
    )

    Turbo::StreamsChannel.broadcast_update_to(
      [ @chatbot, :products ],
      target: "flash",
      partial: "shared/flash_messages",
      locals: { flash: { notice: "#{created_count} products imported successfully." } }
    )

  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Chatbot with ID #{chatbot_id} not found. CSV import aborted: #{e.message}"
    puts "Chatbot with ID #{chatbot_id} not found. CSV import aborted: #{e.message}"
  ensure
    @file.close if @file.present?
  end
end
