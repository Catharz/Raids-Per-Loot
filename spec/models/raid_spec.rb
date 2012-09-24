require 'spec_helper'

describe Raid do
  let(:main) { FactoryGirl.create(:rank, name: 'Main') }
  let(:player) { FactoryGirl.create(:player, name: 'Doofus', rank: main) }
  let(:first_raid) { FactoryGirl.create(:raid, raid_date: Date.today - 60.days) }
  let(:second_raid) { FactoryGirl.create(:raid, raid_date: Date.today - 30.days) }
  let(:third_raid) { FactoryGirl.create(:raid, raid_date: Date.today) }

  describe "self#for_period" do
    it "should show all by default" do
      Raid.for_period.should eq [first_raid, second_raid, third_raid]
    end

    it "should filter by start" do
      Raid.for_period({start: Date.today - 40.days}).should eq [second_raid, third_raid]
    end

    it "should filter by end" do
      Raid.for_period({end: Date.today - 20.days}).should eq [first_raid, second_raid]
    end

    it "should filter by start and end" do
      Raid.for_period({start: Date.today - 40.days, end: Date.today - 20.days}).should eq [second_raid]
    end
  end

  describe "#benched_players" do
    it "should list players with a status of b" do
      FactoryGirl.create(:player_raid, raid_id: first_raid.id, player_id: player.id, status: 'b')
      first_raid.benched_players.should eq [player]
    end

    it "should not list players with a status of a" do
      FactoryGirl.create(:player_raid, raid_id: second_raid.id, player_id: player.id)
      second_raid.benched_players.should eq []
    end
  end
end