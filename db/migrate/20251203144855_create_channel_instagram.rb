class CreateChannelInstagram < ActiveRecord::Migration[8.0]
  def change
    create_table :channel_instagrams do |t|
      t.references :chatbot, null: false, foreign_key: true
      t.string :access_token
      t.datetime :expires_at
      t.string :instagram_id
      t.timestamps
    end
  end
end
