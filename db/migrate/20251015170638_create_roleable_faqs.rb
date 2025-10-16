class CreateRoleableFaqs < ActiveRecord::Migration[8.0]
  def change
    create_table :roleable_faqs do |t|
      t.references :chatbot, null: false, foreign_key: true

      t.timestamps
    end
  end
end
