class AddAdditionalAttributesJsonToContact < ActiveRecord::Migration[8.0]
  def change
    add_column :contacts, :additional_attributes, :jsonb, default: {}
  end
end
