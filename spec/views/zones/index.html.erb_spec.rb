require 'spec_helper'

describe "zones/index.html.erb" do
  before(:each) do
    easy = stub_model(Difficulty, :name => 'Easy', :rating => 1)
    normal = stub_model(Difficulty, :name => 'Normal', :rating => 2)
    hard = stub_model(Difficulty, :name => 'Hard', :rating => 3)
    assign(:difficulties, [easy, normal, hard])
    assign(:zones, [
        stub_model(Zone,
                   :name => "Name",
                   :difficulty => easy
        ),
        stub_model(Zone,
                   :name => "Name",
                   :difficulty => hard
        )
    ])
  end

  it "renders a list of zones" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
