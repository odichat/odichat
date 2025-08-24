class Channel::Playground < ApplicationRecord
  include Channelable
  self.table_name = "channel_playground"
end
