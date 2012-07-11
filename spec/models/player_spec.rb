require 'spec_helper'

module PlayerSpecHelper
  def valid_player_attributes(options = {})
    @main_rank = FactoryGirl.create(:rank, :name => 'Raid Main')
    @alternate_rank = FactoryGirl.create(:rank, :name => 'General Alternate')
    {:name => 'Fred',
     :rank_id => @main_rank.id}.merge!(options)
  end
end

describe Player do
  include PlayerSpecHelper

  describe "player" do
    it "should calculate the loot rate with two decimal places" do
      @player = FactoryGirl.create(:player, valid_player_attributes)
      num_raids = 37
      num_items = 5

      loot_rate = @player.calculate_loot_rate(num_raids, num_items)
      loot_rate.should == 6.17
    end

    it "should be representable as csv" do
      csv = FactoryGirl.create(:player, valid_player_attributes.merge!(:name => 'CSV')).to_csv

      csv.should match('CSV')
      csv.should match('Raid Main')
      csv.split(",").count.should == 10
    end
  end
end