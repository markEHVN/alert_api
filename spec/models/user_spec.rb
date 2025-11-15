require "rails_helper"

RSpec.describe User, type: :model do
  context "associations" do
    it { should have_many(:blog).dependent(:destroy) }
  end

  context "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:role) }
    it { should define_enum_for(:role).with_values([ :user, :admin ]) }
  end

  context "full_name method" do
    it "returns the full name of the user" do
      user = User.new(first_name: "John", last_name: "Doe")
      expect(user.full_name).to eq("John Doe")
    end
  end

  context "generate_auth_token method" do
    it "generates a unique auth token before creating the user" do
      user = User.new(
        email: "test@example.com",
        password: "password",
        first_name: "John",
        last_name: "Doe",
        role: :user
      )
      expect(user.auth_token).to be_nil
      user.save
      expect(user.auth_token).not_to be_nil
    end
  end
end
