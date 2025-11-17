class CreateLeads < ActiveRecord::Migration[8.0]
  def change
    create_table :leads do |t|
      t.references :chatbot, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: true
      t.text :trigger

      t.timestamps
    end
  end
end
