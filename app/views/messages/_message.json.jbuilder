json.extract! message, :id, :chat_id, :sender, :wa_message_id, :assistant_message_id, :content, :created_at, :updated_at
json.url message_url(message, format: :json)
