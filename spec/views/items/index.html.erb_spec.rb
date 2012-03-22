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
    assert_select "tr>td", :text => "Name".to_s, :count => 4
    assert_select "tr>td", :text => "Name".to_s, :count => 4
    assert_select "tr>td", :text => "Name".to_s, :count => 4
  end
end
