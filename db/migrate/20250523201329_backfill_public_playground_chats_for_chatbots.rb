class BackfillPublicPlaygroundChatsForChatbots < ActiveRecord::Migration[7.1]
  def up
    Chatbot.all.each do |chatbot|
      unless chatbot.chats.where(source: "public_playground").exists?
        chatbot.chats.create!(source: "public_playground")
      end
    end
  end

  def down
    Chat.where(source: "public_playground").destroy_all
  end
end
