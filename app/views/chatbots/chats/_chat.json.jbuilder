json.extract! chat, :id, :chatbot_id, :contact_phone, :thread_id, :source, :created_at, :updated_at
json.url chat_url(chat, format: :json)
