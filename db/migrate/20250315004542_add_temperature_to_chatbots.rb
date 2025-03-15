class AddTemperatureToChatbots < ActiveRecord::Migration[8.0]
  def change
    add_column :chatbots, :temperature, :float, default: 0.5
  end
end
