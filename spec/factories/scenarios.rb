FactoryBot.define do
  factory :scenario do
    chatbot { nil }
    name { "MyString" }
    description { "MyText" }
    instruction { "MyText" }
    tools { "" }
  end
end
