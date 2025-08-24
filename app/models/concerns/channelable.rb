module Channelable
  extend ActiveSupport::Concern
  included do
    validates :chatbot_id, presence: true
    belongs_to :chatbot
    has_one :inbox, as: :channel, dependent: :destroy_async, touch: true
  end
end
