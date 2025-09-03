FactoryBot.define do
  factory :chat do
    inbox
    chatbot { inbox.chatbot }
    conversation { association :conversation, chatbot: chatbot }
    source { "playground" }
  end
end
