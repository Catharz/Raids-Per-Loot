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
    @zone.stub!(:mobs).and_return([])
    @zone.stub!(:instances).and_return([])
    @zone.stub!(:items).and_return([])
    @zone.stub!(:drops).and_return([])
  end

  it "renders headings" do
    render

    rendered.should match(/Name/)
    rendered.should match(/Difficulty/)
    rendered.should match(/Named Mobs/)
    rendered.should match(/Runs/)
    rendered.should match(/Drops/)
    rendered.should match(/Progression/)
  end
end
