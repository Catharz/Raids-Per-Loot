require 'spec_helper'

describe "ranks/show.html.erb" do
  before(:each) do
    @rank = assign(:rank, stub_model(Rank,
      :name => "Name",
      :priority => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
