json.extract! chat, :id, :chatbot_id, :contact_id, :thread_id, :source, :created_at, :updated_at
json.url chat_url(chat, format: :json)
