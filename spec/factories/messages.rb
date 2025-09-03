FactoryBot.define do
  factory :message do
    association :chat
    content { "Hello, world!" }
  end
end
