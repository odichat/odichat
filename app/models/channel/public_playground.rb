class Channel::PublicPlayground < ApplicationRecord
  include Channelable

  self.table_name = "channel_public_playground"
end
