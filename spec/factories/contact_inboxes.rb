FactoryBot.define do
  factory :contact_inbox do
    contact
    inbox
    source_id { Faker::PhoneNumber.cell_phone }
  end
end
