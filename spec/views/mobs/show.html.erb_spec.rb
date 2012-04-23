require 'spec_helper'

describe "mobs/show.html.erb" do
  before(:each) do
    easy = stub_model(Difficulty, :name => 'Easy', :rating => 1)
    normal = stub_model(Difficulty, :name => 'Normal', :rating => 2)
    hard = stub_model(Difficulty, :name => 'Hard', :rating => 3)
    assign(:difficulties, [easy, normal, hard])
    @mob = assign(:mob, stub_model(Mob,
                                   :name => "Name",
                                   :strategy => "MyText",
                                   :difficulty => easy
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
