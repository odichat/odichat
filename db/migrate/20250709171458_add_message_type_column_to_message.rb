class AddMessageTypeColumnToMessage < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :message_type, :integer, default: 0, null: false
  end
end
