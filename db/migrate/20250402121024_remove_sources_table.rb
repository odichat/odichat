class RemoveSourcesTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :sources
  end
end
