require "csv"

class Products::ImportFromCsvJob < ApplicationJob
  include Rails.application.routes.url_helpers
  queue_as :default

  def perform(file_path, chatbot_id, refresh_path = nil)
    @chatbot = Chatbot.find(chatbot_id)
    refresh_path ||= chatbot_products_path(@chatbot)
    @file = File.open(file_path)

    return unless @chatbot.present? && @file.present?

    result = @chatbot.products.import_from_csv(@file, @chatbot.id)
    created_count = result[:created_count]
    skipped_count = result[:skipped_count]

    broadcast_products_table(refresh_path)
    broadcast_flash(:notice, "#{created_count} products imported successfully.")
    if skipped_count.positive?
      broadcast_flash(:alert, "#{skipped_count} products were skipped because name and price are required.")
    end

  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Chatbot with ID #{chatbot_id} not found. CSV import aborted: #{e.message}"
    puts "Chatbot with ID #{chatbot_id} not found. CSV import aborted: #{e.message}"
  rescue CSV::MalformedCSVError => e
    Rails.logger.error "Failed to import CSV for chatbot #{chatbot_id}: #{e.message}"
    broadcast_products_table(refresh_path)
    broadcast_flash(:alert, "We couldn't process the CSV file. Please check its format and try again.")
  ensure
    @file.close if @file.present?
    File.delete(file_path) if file_path.present? && File.exist?(file_path)
  end

  private

    def broadcast_products_table(refresh_path)
      return unless @chatbot.present?

      Turbo::StreamsChannel.broadcast_replace_to(
        [ @chatbot, :products ],
        target: "products-table",
        html: ApplicationController.render(
          inline: "<%= turbo_frame_tag 'products-table', src: url %>",
          locals: { url: refresh_path || chatbot_products_path(@chatbot) }
        )
      )
    end

    def broadcast_flash(type, message)
      return unless @chatbot.present?

      Turbo::StreamsChannel.broadcast_update_to(
        [ @chatbot, :products ],
        target: "flash",
        partial: "shared/flash_messages",
        locals: { flash: { type => message } }
      )
    end
end
