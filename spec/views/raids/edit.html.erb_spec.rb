require 'spec_helper'

describe "raids/edit.html.erb" do
  before(:each) do
    @raid = assign(:raid, stub_model(Raid))
  end

  it "renders the edit raid form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => raids_path(@raid), :method => "post" do
    end
  end
end
