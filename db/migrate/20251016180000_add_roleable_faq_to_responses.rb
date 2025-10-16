class AddRoleableFaqToResponses < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def up
    add_reference :responses,
                  :roleable_faq,
                  foreign_key: { to_table: :roleable_faqs },
                  index: { algorithm: :concurrently },
                  null: true

    execute <<~SQL.squish
      UPDATE responses
      SET roleable_faq_id = scenarios.roleable_id
      FROM scenarios
      WHERE responses.scenario_id = scenarios.id
        AND scenarios.roleable_type = 'Roleable::Faq'
    SQL

    change_column_null :responses, :roleable_faq_id, false
  end

  def down
    remove_reference :responses, :roleable_faq, foreign_key: true
  end
end
