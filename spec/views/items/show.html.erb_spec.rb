require 'spec_helper'

describe "items/show.html.erb" do
  before(:each) do
    @item = assign(:item, stub_model(Item,
      :name => "Name",
      :eq2_item_id => "Eq2 Item",
      :info_url => "Info Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Eq2 Item/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Info Url/)
  end
end
