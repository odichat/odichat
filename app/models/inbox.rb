class Inbox < ApplicationRecord
  belongs_to :chatbot
  belongs_to :channel, polymorphic: true
  has_many :contact_inboxes, dependent: :destroy
  has_many :contacts, through: :contact_inboxes
  has_many :chats, dependent: :destroy
  has_many :messages, dependent: :destroy

  def whatsapp_channel?
    channel.is_a?(Channel::Whatsapp)
  end

  def playground_channel?
    channel.is_a?(Channel::Playground)
  end

  def public_playground_channel?
    channel.is_a?(Channel::PublicPlayground)
  end
end
