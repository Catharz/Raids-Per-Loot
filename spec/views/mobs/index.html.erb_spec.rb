require 'spec_helper'

describe "mobs/index.html.erb" do
  before(:each) do
    assign(:mobs, [
      stub_model(Mob,
        :name => "Name",
        :strategy => "MyText"
      ),
      stub_model(Mob,
        :name => "Name",
        :strategy => "MyText"
      )
    ])
  end

  it "renders a list of mobs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
