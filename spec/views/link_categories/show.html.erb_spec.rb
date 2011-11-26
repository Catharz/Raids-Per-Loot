require 'spec_helper'

describe "link_categories/show.html.erb" do
  before(:each) do
    @link_category = assign(:link_category, stub_model(LinkCategory,
      :title => "Title",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
