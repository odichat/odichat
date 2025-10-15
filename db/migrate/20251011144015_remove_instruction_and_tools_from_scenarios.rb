class RemoveInstructionAndToolsFromScenarios < ActiveRecord::Migration[7.0]
  def change
    remove_column :scenarios, :instruction, :text
    remove_column :scenarios, :tools, :jsonb, default: []
  end
end
