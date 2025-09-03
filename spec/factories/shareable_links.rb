FactoryBot.define do
  factory :shareable_link do
    chatbot
    token { SecureRandom.hex(16) }
  end
end
