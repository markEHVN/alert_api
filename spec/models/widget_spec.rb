require 'rails_helper'

RSpec.describe Widget, type: :model do
  it "has none to begin with" do
    expect(Widget.count).to eq 0
  end

  it "has one after adding one" do
    widget = create(:widget)
    expect(Widget.count).to eq 1
    expect(widget.name).to eq "MyString"
  end

  it "has none after one was created in a previous example" do
    expect(Widget.count).to eq 0
  end
end
