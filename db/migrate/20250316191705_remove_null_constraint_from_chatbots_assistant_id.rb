class RemoveNullConstraintFromChatbotsAssistantId < ActiveRecord::Migration[8.0]
  def change
    change_column_null :chatbots, :assistant_id, true
  end
end
