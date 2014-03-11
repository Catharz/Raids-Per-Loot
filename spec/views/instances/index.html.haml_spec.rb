require 'spec_helper'
require 'authentication_spec_helper'

describe 'instances/index' do
  include AuthenticationSpecHelper
  fixtures :users, :services

  before(:each) do
    login_as :admin
    raid_date = Date.parse('2012-01-01')
    raid = assign(:raid, stub_model(Raid, raid_date: raid_date))
    zones = [assign(:zone, stub_model(Zone, name: 'Here')),
             assign(:zone, stub_model(Zone, name: 'There')),
             assign(:zone, stub_model(Zone, name: 'Everywhere'))]
    instances = Array.new(3) { |n|
      stub_model(Instance,
                 raid: raid,
                 zone: zones[n],
                 start_time: raid_date + (18 + n).hours)
    }
    assign(:instances, instances)
  end

  it 'renders table headings' do
    render

    rendered.should contain('Zone')
    rendered.should contain('Start time')
    rendered.should contain('Players')
    rendered.should contain('Characters')
    rendered.should contain('Kills')
  end

  it 'renders a list of instances' do
    render

    rendered.should contain('Here')
    rendered.should contain('There')
    rendered.should contain('Everywhere')
  end
end
