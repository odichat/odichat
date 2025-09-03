FactoryBot.define do
  factory :conversation do
    chatbot
    contact { association :contact, chatbot: chatbot }
  end
end
