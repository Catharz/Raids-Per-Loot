require 'spec_helper'

describe "players/attendance.html.haml" do

  let(:main) { Rank.create(name: 'Main') }
  let(:player) { Player.create(name: 'Jenny', rank: main) }

  before(:each) do
    start_date = Date.today - 2.years
    prog = RaidType.create(name: "Progression")
    @raids = []
    until start_date >= Date.today
      raid = Raid.create(raid_date: start_date, raid_type: prog)
      @raids << raid
      start_date += 1.week
    end
    @raids.each do |raid|
      unless (raid.raid_date.cweek % raid.raid_date.month) == 0 or (raid.raid_date.cweek % (raid.raid_date.month - 1)) == 0
        PlayerRaid.create(raid: raid, player: player )
      end
    end
    player.stub!(:raids_count).and_return(PlayerRaid.count)
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
      rendered.should match '60'
    end

    it "should show all attendance" do
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '57.14'
    end

    it "should show attendance for 1 year" do
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '57.69'
    end

    it "should show attendance for 9 months" do
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '56.41'
    end

    it "should show attendance for 6 months" do
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '53.85'
    end

    it "should show attendance for 3 months" do
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '15.38'
    end

    it "should show attendance for 1 month" do
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '50.00'
    end
  end
end