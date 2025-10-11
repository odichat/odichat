class CreateScenarios < ActiveRecord::Migration[8.0]
  def change
    create_table :scenarios do |t|
      t.references :chatbot, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.text :instruction
      t.jsonb :tools, default: []

      t.timestamps
    end
  end
end
