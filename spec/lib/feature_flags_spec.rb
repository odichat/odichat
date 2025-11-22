require "rails_helper"

RSpec.describe FeatureFlags do
  describe ".v2_enabled_for?" do
    let(:user) { build(:user, email: "new-user@example.com") }

    it "returns false when the flag is disabled in Flipper" do
      allow(Flipper).to receive(:enabled?).with(:v2, user).and_return(false)

      expect(described_class.v2_enabled_for?(user)).to be(false)
    end

    it "returns false for legacy users even if Flipper returns true" do
      legacy_user = build(:user, email: FeatureFlags::V2_LEGACY_USER_EMAILS.first)
      allow(Flipper).to receive(:enabled?).with(:v2, legacy_user).and_return(true)

      expect(described_class.v2_enabled_for?(legacy_user)).to be(false)
    end

    it "returns true for non-legacy users when Flipper returns true" do
      allow(Flipper).to receive(:enabled?).with(:v2, user).and_return(true)

      expect(described_class.v2_enabled_for?(user)).to be(true)
    end
  end

  describe ".v2_group_member?" do
    it "returns false when user is nil" do
      expect(described_class.v2_group_member?(nil)).to be(false)
    end

    it "returns false for legacy email" do
      user = build(:user, email: FeatureFlags::V2_LEGACY_USER_EMAILS.first)

      expect(described_class.v2_group_member?(user)).to be(false)
    end

    it "returns true for non-legacy email" do
      user = build(:user, email: "allowed@example.com")

      expect(described_class.v2_group_member?(user)).to be(true)
    end
  end
end
