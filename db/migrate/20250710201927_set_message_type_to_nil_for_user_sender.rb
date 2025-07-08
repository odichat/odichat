class SetMessageTypeToNilForUserSender < ActiveRecord::Migration[8.0]
  def change
    Message.where(sender: "user").update_all(message_type: nil)
  end
end
