class AddConstraintsToMessagesSender < ActiveRecord::Migration[8.0]
  def change
    change_column_null :messages, :sender, false
  end
end
