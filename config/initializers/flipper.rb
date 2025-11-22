require "flipper/adapters/active_record"
require Rails.root.join("app/lib/feature_flags")

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

# Register a group for users who SHOULD see the V2 features (non legacy users).
Flipper.register(:v2_users) { |user| FeatureFlags.v2_group_member?(user) }
