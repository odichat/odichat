class AddModelIdToChatbots < ActiveRecord::Migration[8.0]
  def change
    add_reference :chatbots, :model, null: true, foreign_key: true
  end
end
exportparts=""
