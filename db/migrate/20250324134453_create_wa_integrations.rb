class CreateWaIntegrations < ActiveRecord::Migration[8.0]
  def change
    create_table :wa_integrations do |t|
      t.belongs_to :chatbot, null: false, foreign_key: true
      t.string :phone_number_id
      t.string :waba_id
      t.string :access_token

      t.timestamps
    end
  end
end
