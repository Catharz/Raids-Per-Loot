require 'spec_helper'

describe "drops/index.html.erb" do
  before(:each) do
    assign(:drops, [
      stub_model(Drop,
        :zone_name => "Zone Name",
        :mob_name => "Mob Name",
        :player_name => "Player Name",
        :item_name => "Item Name",
        :eq2_item_id => "Eq2 Item"
      ),
      stub_model(Drop,
        :zone_name => "Zone Name",
        :mob_name => "Mob Name",
        :player_name => "Player Name",
        :item_name => "Item Name",
        :eq2_item_id => "Eq2 Item"
      )
    ])
  end

  it "renders a list of drops" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Zone Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Mob Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Player Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Item Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Eq2 Item".to_s, :count => 2
  end
end
