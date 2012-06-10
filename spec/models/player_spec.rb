require 'spec_helper'

module PlayerSpecHelper
  def valid_player_attributes
    @main_rank = FactoryGirl.create(:rank, :name => 'Main')
    @alternate_rank = FactoryGirl.create(:rank, :name => 'General Alternate')
    {:name => 'Fred',
     :rank_id => @main_rank.id}
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
  end
end