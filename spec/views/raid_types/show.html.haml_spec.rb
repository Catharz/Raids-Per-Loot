require 'spec_helper'

describe "raid_types/show" do
  before(:each) do
    @raid_type = assign(:raid_type, stub_model(RaidType,
      :name => "Name",
      :raid_counted => false,
      :raid_points => 1.5,
      :loot_counted => true,
      :loot_cost => 2.5
    ))
  end

  it "renders attributes in <p>" do
    render

    rendered.should match(/Name/)
    rendered.should match(/false/)
    rendered.should match(/1.5/)
    rendered.should match(/true/)
    rendered.should match(/2.5/)
  end
end
