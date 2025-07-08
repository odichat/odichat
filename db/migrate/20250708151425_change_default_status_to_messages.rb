class ChangeDefaultStatusToMessages < ActiveRecord::Migration[8.0]
  def change
    change_column_default :messages, :status, from: 0, to: nil
  end
end
