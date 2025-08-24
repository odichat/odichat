class AddInboxIdToMessages < ActiveRecord::Migration[8.0]
  def change
    add_reference :messages, :inbox, foreign_key: true, null: true
  end
end
