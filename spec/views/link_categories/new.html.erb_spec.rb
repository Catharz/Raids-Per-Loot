require 'spec_helper'

describe "link_categories/new.html.erb" do
  before(:each) do
    assign(:link_category, stub_model(LinkCategory,
      :title => "MyString",
      :description => "MyText"
    ).as_new_record)
  end

  it "renders new link_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => link_categories_path, :method => "post" do
      assert_select "input#link_category_title", :name => "link_category[title]"
      assert_select "textarea#link_category_description", :name => "link_category[description]"
    end
  end
end
