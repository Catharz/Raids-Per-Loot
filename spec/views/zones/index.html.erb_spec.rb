require 'spec_helper'

describe "zones/index.html.erb" do
  before(:each) do
    assign(:zones, [
      stub_model(Zone,
        :name => "Name"
      ),
      stub_model(Zone,
        :name => "Name"
      )
    ])
  end

  it "renders a list of zones" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
