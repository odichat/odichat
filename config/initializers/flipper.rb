require "flipper/adapters/active_record"

# Define the list of users who should NOT see the new features.
LEGACY_USER_EMAILS = [
  "soporte.grupopronto@hotmail.com",
  "cryptoversous@gmail.com",
  "andres@odichat.app",
  "marketingcodizulca@gmail.com",
  "hacobobarich@gmail.com",
  "elimeycosmetics@gmail.com",
  "ferronortehomeventas@gmail.com",
  "farmaexpress@test.com",
  "smdcentroia@gmail.com",
  "distribuidorakatys@gmail.com",
].freeze

Rails.application.configure do
  config.flipper.memoize = true
  config.flipper.preload = true
end

Flipper.configure do |config|
  config.default do
    adapter = Flipper::Adapters::ActiveRecord.new
    Flipper.new(adapter)
  end
end

# Register a group for users who SHOULD see the V2 features.
# This is everyone *not* in the legacy list.
Flipper.register(:v2_users) do |user|
  user.present? && !LEGACY_USER_EMAILS.include?(user.email)
end
