require 'spec_helper'

describe "drops/edit.html.erb" do
  before(:each) do
    @drop = assign(:drop, stub_model(Drop,
      :zone_name => "MyString",
      :mob_name => "MyString",
      :player_name => "MyString",
      :item_name => "MyString",
      :eq2_item_id => "MyString"
    ))
  end

  it "renders the edit drop form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => drops_path(@drop), :method => "post" do
      assert_select "input#drop_zone_name", :name => "drop[zone_name]"
      assert_select "input#drop_mob_name", :name => "drop[mob_name]"
      assert_select "input#drop_player_name", :name => "drop[player_name]"
      assert_select "input#drop_item_name", :name => "drop[item_name]"
      assert_select "input#drop_eq2_item_id", :name => "drop[eq2_item_id]"
    end
  end
end
