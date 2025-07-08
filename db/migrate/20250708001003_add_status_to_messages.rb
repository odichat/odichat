class AddStatusToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :status, :integer, default: 0
  end
end
