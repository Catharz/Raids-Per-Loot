require 'spec_helper'

describe "ranks/index.html.erb" do
  before(:each) do
    assign(:ranks, [
      stub_model(Rank,
        :name => "Name",
        :priority => 1
      ),
      stub_model(Rank,
        :name => "Name",
        :priority => 1
      )
    ])
  end

  it "renders a list of ranks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
