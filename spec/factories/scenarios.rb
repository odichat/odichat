FactoryBot.define do
  factory :scenario do
    association :chatbot
    name { "MyString" }
    description { "MyText" }
    association :roleable, factory: :roleable_product_inventory
  end
end
