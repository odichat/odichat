class RemoveIsTimeAwareColumnFromChatbots < ActiveRecord::Migration[8.0]
  def change
    remove_column :chatbots, :is_time_aware, :boolean
  end
end
