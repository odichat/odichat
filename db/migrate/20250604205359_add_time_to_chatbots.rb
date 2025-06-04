class AddTimeToChatbots < ActiveRecord::Migration[8.0]
  def change
    add_column :chatbots, :is_time_aware, :boolean, default: false, null: false
    add_column :chatbots, :timezone, :string
  end
end
