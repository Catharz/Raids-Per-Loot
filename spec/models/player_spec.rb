require 'spec_helper'

describe Player do
  let(:main) { FactoryGirl.create(:rank, name: 'Main') }
  let(:player) { FactoryGirl.create(:player, name: 'Fred', rank: main) }

  describe "player" do
    describe "#calculate_loot_rate" do
      it "should calculate the loot rate with two decimal places" do
        num_raids = 37
        num_items = 5

        loot_rate = player.calculate_loot_rate(num_raids, num_items)
        loot_rate.should == 6.17
      end
    end

    describe "#to_csv" do
      it "should have 10 columns" do
        csv = player.to_csv

        csv.should match('Fred')
        csv.should match('Main')
        csv.split(",").count.should == 10
      end
    end

    describe "#attendance" do
      it "should return all attendance by default" do
        player.stub!(:raids_attended).and_return([1, 2, 3])
        Raid.stub!(:for_period).and_return(4)
        player.should_receive(:attendance).and_return(75.00)
        player.attendance.should eq 75.00
      end
    end

    describe "#rank_name" do
      it "should return the rank name if set" do
        player.rank_name.should eq "Main"
      end

      it "should return Unknown if not set" do
        player.rank = nil

        player.rank_name.should eq "Unknown"
      end
    end
  end
end