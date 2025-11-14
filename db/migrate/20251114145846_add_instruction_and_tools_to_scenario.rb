class AddInstructionAndToolsToScenario < ActiveRecord::Migration[8.0]
  def change
    add_column :scenarios, :instruction, :string
    add_column :scenarios, :tools, :jsonb, default: []
  end
end
