FactoryBot.define do
  factory :inbox do
    chatbot
    channel { association :channel_whatsapp, chatbot: chatbot }

    trait :whatsapp do
      channel { association :channel_whatsapp, chatbot: chatbot }
    end

    trait :playground do
      channel { association :channel_playground, chatbot: chatbot }
    end

    trait :public_playground do
      channel { association :channel_public_playground, chatbot: chatbot }
    end
  end
end
