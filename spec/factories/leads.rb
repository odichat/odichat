FactoryBot.define do
  factory :lead do
    chatbot { nil }
    contact { nil }
    trigger { "MyText" }
  end
end
