require 'spec_helper'

describe Raid do
  describe "for_period" do
    let(:first_raid) { FactoryGirl.create(:raid, raid_date: Date.today - 60.days) }
    let(:second_raid) { FactoryGirl.create(:raid, raid_date: Date.today - 30.days) }
    let(:third_raid) { FactoryGirl.create(:raid, raid_date: Date.today) }

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
end