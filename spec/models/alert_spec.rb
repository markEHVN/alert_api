require "rails_helper"

RSpec.describe Alert, type: :model do
  describe "associations" do
    # TODO: Test belongs_to :user
    it { should belong_to(:user) }
    it { should have_many(:alert_subscriptions).dependent(:destroy) }
  end

  describe "validations" do
    # TODO: Test title presence and length
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(255) }
    # TODO: Test severity inclusion
    it { should validate_inclusion_of(:severity).in_array(%w[low medium high critical]) }
  end

  describe "#acknowledge!" do
    let(:alert) { create(:alert, status: :active) }
    let(:user) { create(:user) }
    # TODO: Test status change and timestamp
    it "changes status to acknowledged" do
      alert.acknowledge!(user)
      expect(alert.status).to eq("acknowledged")
      expect(alert.acknowledged_at).to be_present
      expect(alert.metadata["acknowledged_by"]).to eq(user.id)
    end
  end

  describe "#overdue?" do
    # TODO: Test overdue logic
    it "returns true for active alerts older than 24 hours" do
      alert = create(:alert, status: :active, created_at: 25.hours.ago)
      expect(alert.overdue?).to be true
    end

    it "returns false for recent alerts" do
      alert = create(:alert, status: :active, created_at: 1.hour.ago)
      expect(alert.overdue?).to be false
    end
  end
end
