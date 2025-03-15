class CreateModels < ActiveRecord::Migration[8.0]
  def change
    create_table :models do |t|
      t.string :name, null: false
      t.string :description, null: true
      t.string :provider, null: false
      t.timestamps
    end

    add_index :models, :name, unique: true
  end
end
