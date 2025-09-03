FactoryBot.define do
  factory :model do
    name { "gpt-5-nano" }
    provider { "openai" }
  end
end
