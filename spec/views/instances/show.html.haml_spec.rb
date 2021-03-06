require 'spec_helper'

describe 'instances/show' do

  before(:each) do
    raid = assign(:raid, stub_model(Raid, raid_date: Date.parse('2012-01-01')))
    zone = assign(:zone, stub_model(Zone, name: 'Wherever'))
    start_time = DateTime.parse('2012-01-01T18:00+10:00')
    @instance = assign(:instance, stub_model(Instance,
                                             raid: raid,
                                             zone: zone,
                                             start_time: start_time))
    @instance.stub(:instances).and_return([])
    @instance.stub(:kills).and_return([])
    @instance.stub(:players).and_return([])
    @instance.stub(:characters).and_return([])
    @instance.stub(:drops).and_return([])
  end

  it 'renders basic stats for the instance' do
    render

    rendered.should contain('Zone: Wherever')
    rendered.should contain('Start time:')
    rendered.should contain('Players:')
    rendered.should contain('Characters:')
    rendered.should contain('Kills:')
    rendered.should contain('Drops:')
  end

  it 'displays tabs for related data' do
    render

    rendered.should contain('Instances')
    rendered.should contain('Kills')
    rendered.should contain('Players')
    rendered.should contain('Characters')
    rendered.should contain('Drops')
  end
end
