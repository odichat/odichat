class AddStatusToDocuments < ActiveRecord::Migration[8.0]
  def change
    # AIDEV-NOTE: Using integer type to back the `status` enum in the Document model.
    # The default is 0, which maps to :pending. `null: false` ensures data integrity.
    add_column :documents, :status, :integer, default: 0, null: false
    add_index :documents, :status
  end
end
