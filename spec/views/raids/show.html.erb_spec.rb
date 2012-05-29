require 'spec_helper'

describe "raids/show.html.erb" do

  before(:each) do
    @raid = assign(:raid, stub_model(Raid, :raid_date => Date.parse("01/01/2011")))
    @raid.stub!(:instances).and_return([])
    @raid.stub!(:kills).and_return([])
    @raid.stub!(:players).and_return([])
    @raid.stub!(:characters).and_return([])
    @raid.stub!(:drops).and_return([])
  end

  it "renders attributes in <p>" do
    render

    rendered.should contain("2011-01-01")
  end

  it "displays stats for related data" do
    render

    rendered.should contain("Instances: 0")
    rendered.should contain("Players: 0")
    rendered.should contain("Characters: 0")
    rendered.should contain("Kills: 0")
    rendered.should contain("Drops: 0")
  end

  it "displays tabs for related data" do
    render

    rendered.should contain("Instances")
    rendered.should contain("Kills")
    rendered.should contain("Players")
    rendered.should contain("Characters")
    rendered.should contain("Drops")
  end
end
