class AddRoleableToScenarios < ActiveRecord::Migration[7.0]
  def change
    add_reference :scenarios, :roleable, polymorphic: true
  end
end
