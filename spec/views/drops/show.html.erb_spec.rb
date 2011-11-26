require 'spec_helper'

describe "drops/show.html.erb" do
  before(:each) do
    @drop = assign(:drop, stub_model(Drop,
      :zone_name => "Zone Name",
      :mob_name => "Mob Name",
      :player_name => "Player Name",
      :item_name => "Item Name",
      :eq2_item_id => "Eq2 Item"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Zone Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Mob Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Player Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Item Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Eq2 Item/)
  end
end
