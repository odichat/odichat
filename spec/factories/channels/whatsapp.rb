FactoryBot.define do
  factory :channel_whatsapp, class: 'Channel::Whatsapp' do
    chatbot
    phone_number_id { "#{Faker::Number.number(digits: 10)}" }
    access_token { SecureRandom.hex }
    business_account_id { SecureRandom.hex }
  end
end
