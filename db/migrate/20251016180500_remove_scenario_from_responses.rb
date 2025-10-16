class RemoveScenarioFromResponses < ActiveRecord::Migration[8.0]
  def change
    remove_reference :responses, :scenario, index: true, foreign_key: true
  end
end
