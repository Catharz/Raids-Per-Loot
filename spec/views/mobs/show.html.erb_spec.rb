require 'spec_helper'

describe "mobs/show.html.erb" do
  before(:each) do
    @mob = assign(:mob, stub_model(Mob,
      :name => "Name",
      :strategy => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
