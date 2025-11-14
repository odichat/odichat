class AddChatbotReferenceToResponses < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def up
    add_reference :responses,
                  :chatbot,
                  foreign_key: true,
                  null: false
  end

  def down
    remove_reference :responses, :chatbot, foreign_key: true
  end
end
