require 'spec_helper'

describe "link_categories/index.html.erb" do
  before(:each) do
#    login_as :quentin
    assign(:link_categories, [
      stub_model(LinkCategory,
        :title => "Title",
        :description => "MyText"
      ),
      stub_model(LinkCategory,
        :title => "Title",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of link_categories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
