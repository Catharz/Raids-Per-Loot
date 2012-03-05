require 'spec_helper'

describe "viewer/show.html.erb" do
  fixtures :users

  before(:each) do
    login_as users(:quentin)
  end

  it "renders the page contents" do
    assign(:page, stub_model(Page, :name => "home", :title => "Home", :navlabel => "Home", :body => "Hello World!"))

    render

    rendered.should match(/Hello World!/)
  end
end
