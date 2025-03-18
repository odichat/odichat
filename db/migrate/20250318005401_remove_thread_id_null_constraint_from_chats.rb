class RemoveThreadIdNullConstraintFromChats < ActiveRecord::Migration[8.0]
  def change
    change_column_null :chats, :thread_id, true
  end
end
