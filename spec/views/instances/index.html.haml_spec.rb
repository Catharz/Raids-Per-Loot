require 'spec_helper'

describe "instances/index.html.haml" do
  fixtures :users, :services

  before(:each) do
    login_as :admin
    raid = assign(:raid, stub_model(Raid, :raid_date => Date.parse("2012-01-01")))
    zone1 = assign(:zone, stub_model(Zone, :name => 'Here'))
    zone2 = assign(:zone, stub_model(Zone, :name => 'There'))
    zone3 = assign(:zone, stub_model(Zone, :name => 'Everywhere'))
    assign(:instances, [
        stub_model(Instance, :raid => raid, :zone => zone1, :start_time => DateTime.parse("2012-01-01T18:00+10:00")),
        stub_model(Instance, :raid => raid, :zone => zone2, :start_time => DateTime.parse("2012-01-02T18:00+10:00")),
        stub_model(Instance, :raid => raid, :zone => zone3, :start_time => DateTime.parse("2012-01-03T18:00+10:00"))
    ])
  end

  it "renders table headings" do
    render

    rendered.should contain("Zone")
    rendered.should contain("Start time")
    rendered.should contain("Players")
    rendered.should contain("Characters")
    rendered.should contain("Kills")
  end

  it "renders a list of instances" do
    render

    rendered.should contain("Here")
    rendered.should contain("There")
    rendered.should contain("Everywhere")
  end
end
