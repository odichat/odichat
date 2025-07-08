class AddSourceIdToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :source_id, :string
  end
end
