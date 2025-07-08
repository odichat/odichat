class AddContentAttributesToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :content_attributes, :json, default: {}
  end
end
