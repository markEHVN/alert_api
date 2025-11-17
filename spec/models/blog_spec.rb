require 'rails_helper'

RSpec.describe Blog, type: :model do
  context "associations" do
    it { should belong_to(:user) }
  end

  context "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:status) }
    # enum of status
    it { should define_enum_for(:status).with_values([ :draft, :published, :archived ]) }
  end
end
