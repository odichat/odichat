FactoryBot.define do
  factory :response do
    chatbot { nil }
    question { "MyString" }
    answer { "MyString" }
  end
end
