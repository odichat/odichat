class AddUniqueConstraintToShareableLinkToken < ActiveRecord::Migration[8.0]
  def change
    add_index :shareable_links, :token, unique: true
  end
end
