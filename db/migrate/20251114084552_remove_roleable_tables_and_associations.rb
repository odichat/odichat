class RemoveRoleableTablesAndAssociations < ActiveRecord::Migration[8.0]
  def up
    if column_exists?(:responses, :roleable_faq_id)
      remove_reference :responses, :roleable_faq, foreign_key: true
    end

    if column_exists?(:scenarios, :roleable_id) && column_exists?(:scenarios, :roleable_type)
      remove_reference :scenarios, :roleable, polymorphic: true
    end

    drop_table :products, if_exists: true
    drop_table :roleable_product_inventories, if_exists: true
    drop_table :roleable_faqs, if_exists: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Roleable tables and associations cannot be restored automatically"
  end
end
