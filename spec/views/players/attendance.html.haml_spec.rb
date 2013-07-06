require 'spec_helper'

describe 'players/attendance.html.haml' do

  let(:main) { Rank.create(name: 'Main') }
  let(:player) { Player.create(name: 'Jenny', rank: main) }

  before(:each) do
    Timecop.freeze(Date.parse('2013-04-01'))
    raid_date = Date.today - 13.months
    prog = RaidType.create(name: 'Progression')
    @raids = []
    until raid_date >= Date.today
      if raid_date > (Date.today - 9.months)
        if [3].include? raid_date.cwday # Raids on Wed
          raid = Raid.create(raid_date: raid_date, raid_type: prog)
          @raids << raid
        end
      else
        if [5, 6].include? raid_date.cwday # Raids on Fri & Sat
          raid = Raid.create(raid_date: raid_date, raid_type: prog)
          @raids << raid
        end
      end
      raid_date += 1.day
    end
    @raids.each do |raid|
      unless (raid.raid_date.cweek % raid.raid_date.cwday) == 0
        PlayerRaid.create(raid: raid, player: player )
      end
    end
    player.stub!(:raids_count).and_return(PlayerRaid.count)
  end

  after(:each) do
    Timecop.return
  end

  context 'layout' do
    it 'should show all headings' do
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

  context 'time periods' do
    it 'should show the total raid count' do
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '55'
    end

    it 'should show all attendance' do
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '73.33'
    end

    it 'should show attendance for 1 year' do
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '72.73'
    end

    it 'should show attendance for 9 months' do
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '67.50'
    end

    it 'should show attendance for 6 months' do
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '69.23'
    end

    it 'should show attendance for 3 months' do
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '69.23'
    end

    it 'should show attendance for 1 month' do
      assign(:players, [player])

      render

      rendered.should match 'Jenny'
      rendered.should match '75.00'
    end
  end
end