FactoryBot.define do
  factory :vector_store do
    association :chatbot
    name { "Vector Store - #{Faker::Company.name}" }
    vector_store_id { "vs_#{Faker::Alphanumeric.alphanumeric(number: 24)}" }
  end
end
