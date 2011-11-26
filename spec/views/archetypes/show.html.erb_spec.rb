require 'spec_helper'

describe "archetypes/show.html.erb" do
  before(:each) do
    @archetype = assign(:archetype, stub_model(Archetype,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
