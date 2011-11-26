require 'spec_helper'

describe "zones/edit.html.erb" do
  before(:each) do
    @zone = assign(:zone, stub_model(Zone,
      :name => "MyString"
    ))
  end

  it "renders the edit zone form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => zones_path(@zone), :method => "post" do
      assert_select "input#zone_name", :name => "zone[name]"
    end
  end
end
