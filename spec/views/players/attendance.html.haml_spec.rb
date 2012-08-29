require 'spec_helper'

describe "players/attendance.html.haml" do

  let(:main) { Rank.create(name: 'Main') }
  let(:player) { Player.create(name: 'Jenny', rank: main) }
  let(:scout) { Archetype.create(name: 'Scout') }
  let(:character) { Character.create(name: 'Jenny', player: player, archetype: scout, char_type: 'm')}
  let(:zone) { Zone.create(name: 'Wherever') }

  before(:each) do
    @t = Time.parse("01/07/2012 20:15")
    d = Date.parse("01/07/2012")
    @raids = []
    @instances = []
    for n in 0..100
      raid = Raid.create(raid_date: d - n.weeks)
      instance = Instance.create(raid: raid, zone: zone, start_time: raid.raid_date + 18.hours)
      @instances << instance
      @raids << raid
    end
    Time.should_receive(:now).at_least(1).times.and_return(@t)
    @instances.each do |i|
      unless (i.raid.raid_date.cweek % i.raid.raid_date.month) == 0 or (i.raid.raid_date.cweek % (i.raid.raid_date.month - 1)) == 0
        CharacterInstance.create(instance: i, character: character )
      end
    end
    player.stub!(:raids_count).and_return(CharacterInstance.count)
  end

  context "layout" do
    it "should show all headings" do
      assign(:players, [player])

      render

      rendered.should match 'Name'
      rendered.should match 'First Raid'
      rendered.should match 'Last Raid'
      rendered.should match 'Total Raids'
      rendered.should match 'Total Attendance'
      rendered.should match '1 Year'
      rendered.should match '9 Months'
      rendered.should match '6 Months'
      rendered.should match '3 Months'
      rendered.should match '1 Month'
    end
  end

  context "time periods" do
    it "should show the total raid count" do
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '55'
    end

    it "should show all attendance" do
      Time.should_receive(:now).at_least(1).times.and_return(@t)
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '54.46'
    end

    it "should show attendance for 1 year" do
      Time.should_receive(:now).at_least(1).times.and_return(@t)
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '54.72'
    end

    it "should show attendance for 9 months" do
      Time.should_receive(:now).at_least(1).times.and_return(@t)
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '50.00'
    end

    it "should show attendance for 6 months" do
      Time.should_receive(:now).at_least(1).times.and_return(@t)
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '37.04'
    end

    it "should show attendance for 3 months" do
      Time.should_receive(:now).at_least(1).times.and_return(@t)
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '64.29'
    end

    it "should show attendance for 1 month" do
      Time.should_receive(:now).at_least(1).times.and_return(@t)
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '60.00'
    end
  end
end