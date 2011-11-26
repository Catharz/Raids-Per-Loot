require 'spec_helper'

describe "items/index.html.erb" do
  before(:each) do
    assign(:items, [
      stub_model(Item,
        :name => "Name",
        :eq2_item_id => "Eq2 Item",
        :info_url => "Info Url"
      ),
      stub_model(Item,
        :name => "Name",
        :eq2_item_id => "Eq2 Item",
        :info_url => "Info Url"
      )
    ])
  end

  it "renders a list of items" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Eq2 Item".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Info Url".to_s, :count => 2
  end
end
