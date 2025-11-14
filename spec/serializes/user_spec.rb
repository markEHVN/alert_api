require "rails_helper"

RSpec.describe UserSerializer do
  describe "serialization" do
    let(:user) { build(:user) }
    let(:serializer) { described_class.new(user) }
    let(:serialized_json) { serializer.serializable_hash }

    it "includes the expected attributes" do
      expect(serialized_json[:data][:attributes]).to include(
        :id,
        :email,
        :first_name,
        :last_name,
        :role,
        :full_name
      )
    end
  end
end
