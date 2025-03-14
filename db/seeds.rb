# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if Rails.env.development?
  # Create a test user
  user = User.find_or_create_by!(email: 'user@example.com') do |u|
    u.password = '123456'
    u.password_confirmation = '123456'
  end

  # Create a chatbot for the user
  Chatbot.find_or_create_by!(assistant_id: 'asst_AFGyRQRz0BgEOW0kmjFg9wsg') do |chatbot|
    chatbot.name = 'My Assistant'
    chatbot.user = user
  end
end
