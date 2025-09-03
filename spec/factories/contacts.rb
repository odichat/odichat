FactoryBot.define do
  factory :contact do
    association :chatbot
    phone_number { Faker::PhoneNumber.unique.phone_number }
  end
end
