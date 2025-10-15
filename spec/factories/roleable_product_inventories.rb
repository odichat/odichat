FactoryBot.define do
  factory :roleable_product_inventory, class: "Roleable::ProductInventory" do
    association :chatbot
  end
end
