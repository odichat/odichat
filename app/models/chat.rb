class Chat < ApplicationRecord
  include OpenaiClient

  belongs_to :chatbot
  belongs_to :contact, optional: true

  has_many :messages, dependent: :destroy

  validates :source, presence: true

  def toggle_intervention!
    if intervention_enabled?
      disable_intervention!
    else
      enable_intervention!
    end
  end

  def enable_intervention!
    update(
      intervention_enabled: true,
      intervened_at: Time.current
    )
  end

  def disable_intervention!
    update(
      intervention_enabled: false,
      intervened_at: nil
    )
  end

  def whatsapp_channel?
    source == "whatsapp"
  end

  def playground_channel?
    source == "playground"
  end

  def public_playground_channel?
    source == "public_playground"
  end

  def whatsapp_reply_window_open?
    whatsapp_channel? && (messages.where(sender: "user").last&.created_at > 24.hours.ago)
  end
end
