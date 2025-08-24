class MigrateInboxIdToMessages < ActiveRecord::Migration[8.0]
  def change
    Message.where(inbox_id: nil).each do |message|
      message.update(inbox_id: message.chat.inbox_id)
    end
  end
end
