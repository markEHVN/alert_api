require "rails_helper"

RSpec.describe BlogSerializer do
  let(:blog) { build(:blog) }
  let(:serializer) { described_class.new(blog) }
  let(:serialized_json) { serializer.serializable_hash }

  it "serializes the blog correctly" do
    expect(serialized_json[:data][:attributes]).to include(
      :title,
      :content,
      :author_id,
      :author_name
    )
  end
end
