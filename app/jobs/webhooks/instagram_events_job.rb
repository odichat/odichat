class Webhooks::InstagramEventsJob < ApplicationJob
  queue_as :default

  SUPPORTED_EVENTS = [ :message, :read ].freeze

  def perform(entries)
    @entries = entries

    lock_name = "#{sender_id}:#{ig_account_id}"

    # ActiveRecord::Base.with_advisory_lock(lock_name) do
      process_entries(entries)
    # end
  end

  def process_entries(entries)
    entries.each do |entry|
      process_single_entry(entry.with_indifferent_access)
    end
  end

  private

  def process_single_entry(entry)
    if test_event?(entry)
      process_test_event(entry)
      return
    end

    process_messages(entry)
  end

  def process_test_event(entry)
    puts "**************TEST EVENT****************"
    puts entry
  end

  def process_messages(entry)
    messages(entry).each do |messaging|
      Rails.logger.info("Instagram Events Job Messaging: #{messaging}")
      puts "Instagram Events Job Messaging: #{messaging}"

      # https://developers.facebook.com/docs/instagram-platform/webhooks/examples
      instagram_id = instagram_id(messaging)
      channel = find_channel(instagram_id)

      next if channel.blank?

      if (event_name = event_name(messaging))
        send(event_name, messaging, channel)
      end
    end
  end

  def message(messaging, channel)
    Instagram::MessageText.new(messaging, channel).perform
  end

  def read(messaging, channel)
    # Use a single service to handle read status for both channel types since the params are same
    # ::Instagram::ReadStatusService.new(params: messaging, channel: channel).perform
    puts "Instagram Events Job Read: #{messaging}"
  end

  def event_name(messaging)
    @event_name ||= SUPPORTED_EVENTS.find { |key| messaging.key?(key) }
  end

  def find_channel(instagram_id)
    Channel::Instagram.find_by(instagram_id: instagram_id)
  end

  def instagram_id(messaging)
    if agent_message_via_echo?(messaging)
      messaging[:sender][:id]
    else
      messaging[:recipient][:id]
    end
  end

  def agent_message_via_echo?(messaging)
    messaging[:message].present? && messaging[:message][:is_echo].present?
  end

  def messages(entry)
    (entry[:messaging].presence || entry[:standby] || [])
  end

  def test_event?(entry)
    entry[:changes].present?
  end

  def ig_account_id
    @entries&.first&.dig(:id)
  end

  def sender_id
    @entries&.dig(0, :messaging, 0, :sender, :id)
  end
end
