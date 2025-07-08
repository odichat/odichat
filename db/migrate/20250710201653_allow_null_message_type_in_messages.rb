class AllowNullMessageTypeInMessages < ActiveRecord::Migration[8.0]
  def change
    change_column_null :messages, :message_type, true
  end
end
