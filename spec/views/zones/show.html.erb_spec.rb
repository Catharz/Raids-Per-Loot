require 'spec_helper'

describe "zones/show.html.erb" do
  before(:each) do
    easy = stub_model(Difficulty, :name => 'Easy', :rating => 1)
    normal = stub_model(Difficulty, :name => 'Normal', :rating => 2)
    hard = stub_model(Difficulty, :name => 'Hard', :rating => 3)
    assign(:difficulties, [easy, normal, hard])
    @zone = assign(:zone, stub_model(Zone,
                                     :name => "Name",
                                     :difficulty => easy
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
