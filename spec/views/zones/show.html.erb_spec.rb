require 'spec_helper'

describe "zones/show.html.erb" do
  before(:each) do
    @zone = assign(:zone, stub_model(Zone,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
