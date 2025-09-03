FactoryBot.define do
  factory :chatbot do
    user
    name { "My Chatbot" }
    model_id { Model.find_or_create_by!(name: 'gpt-5-nano', provider: 'openai').id }
  end
end
