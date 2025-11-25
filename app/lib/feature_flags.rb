module FeatureFlags
  V2_LEGACY_USER_EMAILS = [
    "soporte.grupopronto@hotmail.com",
    "cryptoversous@gmail.com",
    "marketingcodizulca@gmail.com",
    "hacobobarich@gmail.com",
    "ferronortehomeventas@gmail.com",
    "farmaexpress@test.com",
    "smdcentroia@gmail.com"
  ].freeze

  module_function

  def v2_enabled_for?(user)
    Flipper.enabled?(:v2, user) && v2_group_member?(user)
  end

  def v2_group_member?(user)
    user.present? && !V2_LEGACY_USER_EMAILS.include?(user.email)
  end
end
