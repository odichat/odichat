class CreateChannelWhatsappTable < ActiveRecord::Migration[8.0]
  def change
    create_table :channel_whatsapp do |t|
      t.references :chatbot, null: false, foreign_key: true
      t.string :phone_number_id
      t.string :business_account_id
      t.string :access_token
      t.boolean :subscribed

      t.timestamps
    end
  end
end
