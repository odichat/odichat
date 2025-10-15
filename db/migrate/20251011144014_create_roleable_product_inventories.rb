class CreateRoleableProductInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :roleable_product_inventories do |t|
      t.references :chatbot, null: false, foreign_key: true
      t.timestamps
    end

    create_table :products do |t|
      t.references :roleable_product_inventory, null: false, foreign_key: { to_table: :roleable_product_inventories }
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.timestamps
    end

    add_index :products, :name
  end
end
