# frozen_string_literal: true

class BackfillChatbotData < ActiveRecord::Migration[8.0]
  # class Chatbot < ApplicationRecord
  #   has_one :waba
  #   has_many :chats
  #   has_many :contacts
  #   has_many :inboxes
  #   has_many :whatsapp_channels, class_name: "Channel::Whatsapp"
  #   has_many :playground_channels, class_name: "Channel::Playground"
  #   has_many :public_playground_channels, class_name: "Channel::PublicPlayground"
  # end

  # class Waba < ApplicationRecord
  #   belongs_to :chatbot
  # end

  # class Chat < ApplicationRecord
  #   belongs_to :chatbot
  #   belongs_to :inbox
  #   belongs_to :contact, optional: true
  #   belongs_to :contact_inbox, optional: true
  #   has_many :messages
  # end

  # class Message < ApplicationRecord
  #   belongs_to :chat
  #   belongs_to :inbox, optional: true
  # end

  # class Inbox < ApplicationRecord
  #   belongs_to :chatbot
  #   belongs_to :channel, polymorphic: true
  #   has_many :contact_inboxes
  #   has_many :contacts, through: :contact_inboxes
  #   has_many :chats
  #   has_many :messages
  # end

  # class ContactInbox < ApplicationRecord
  #   belongs_to :contact
  #   belongs_to :inbox
  #   has_many :chats
  # end

  # class Channel::Playground < ApplicationRecord
  #   belongs_to :chatbot
  #   has_one :inbox, as: :channel
  # end

  # class Channel::PublicPlayground < ApplicationRecord
  #   belongs_to :chatbot
  #   has_one :inbox, as: :channel
  # end

  # class Channel::Whatsapp < ApplicationRecord
  #   belongs_to :chatbot
  #   has_one :inbox, as: :channel
  # end

  def up
    Chatbot.find_each do |chatbot|
      # Create Playground and Public Playground channels and inboxes
      playground_channel = Channel::Playground.find_or_create_by!(chatbot: chatbot)
      Inbox.find_or_create_by!(chatbot: chatbot, channel: playground_channel)

      public_playground_channel = Channel::PublicPlayground.find_or_create_by!(chatbot: chatbot)
      Inbox.find_or_create_by!(chatbot: chatbot, channel: public_playground_channel)

      # Handle WhatsApp channel and inbox if waba exists
      if chatbot.waba.present? && chatbot.waba.phone_number_id.present?
        whatsapp_channel = Channel::Whatsapp.find_or_create_by!(phone_number_id: chatbot.waba.phone_number_id) do |channel|
          channel.chatbot = chatbot
          channel.business_account_id = chatbot.waba.waba_id
          channel.access_token = chatbot.waba.access_token
          channel.subscribed = chatbot.waba.subscribed
        end
        Inbox.find_or_create_by!(chatbot: chatbot, channel: whatsapp_channel)
      end

      # Update chats and messages
      chatbot.chats.find_each do |chat|
        inbox = find_inbox_for_chat(chatbot, chat.source)
        if inbox
          chat.update!(inbox_id: inbox.id)
          chat.messages.update_all(inbox_id: inbox.id)

          if chat.source == 'whatsapp' && chat.contact.present?
            contact_inbox = ContactInbox.find_or_create_by!(contact: chat.contact, inbox: inbox) do |ci|
              ci.source_id = chat.contact.phone_number
            end
            chat.update!(contact_inbox_id: contact_inbox.id)
          end
        end
      end
    end
  end

  def down
    # This migration is not reversible as it creates new records and modifies existing ones.
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def find_inbox_for_chat(chatbot, source)
    case source
    when 'playground'
      chatbot.inboxes.find_by(channel_type: 'Channel::Playground')
    when 'public_playground'
      chatbot.inboxes.find_by(channel_type: 'Channel::PublicPlayground')
    when 'whatsapp'
      chatbot.inboxes.find_by(channel_type: 'Channel::Whatsapp')
    end
  end
end
