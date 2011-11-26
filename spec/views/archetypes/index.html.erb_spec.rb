require 'spec_helper'

describe "archetypes/index.html.erb" do
  before(:each) do
    assign(:archetypes, [
      stub_model(Archetype,
        :name => "Name"
      ),
      stub_model(Archetype,
        :name => "Name"
      )
    ])
  end

  it "renders a list of archetypes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
