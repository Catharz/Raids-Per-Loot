require 'spec_helper'

describe "loot_types/show.html.erb" do
  before(:each) do
    @loot_type = assign(:loot_type, stub_model(LootType,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
