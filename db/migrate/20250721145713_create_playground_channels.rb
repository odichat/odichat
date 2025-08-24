class CreatePlaygroundChannels < ActiveRecord::Migration[8.0]
  def change
    create_table :channel_playground do |t|
      t.references :chatbot, null: false, foreign_key: true
      t.jsonb :settings, default: {}
      t.timestamps
    end

    create_table :channel_public_playground do |t|
      t.references :chatbot, null: false, foreign_key: true
      t.jsonb :settings, default: {}
      t.timestamps
    end
  end
end
