require 'spec_helper'

describe Player do
  describe "player" do
    before(:each) do
      @player = Factory.create(:player, :name => 'Fred')
    end

    it "should calculate the loot rate with two decimal places" do
      num_raids = 37
      num_items = 5

      loot_rate = @player.calculate_loot_rate(num_raids, num_items)
      loot_rate.should == 6.17
    end
  end
end
