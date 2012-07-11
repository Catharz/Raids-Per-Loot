require 'spec_helper'
require 'character_spec_helper'

describe Character do
  include CharacterSpecHelper

  before(:each) do
    @character = FactoryGirl.create(:character, valid_character_attributes)
  end

  describe "character" do
    it "should calculate the loot rate with two decimal places" do
      num_raids = 37
      num_items = 5

      loot_rate = @character.calculate_loot_rate(num_raids, num_items)
      loot_rate.should == 6.17
    end

    it "should be representable as csv" do
      csv = FactoryGirl.create(:character, valid_character_attributes.merge!(:name => 'CSV')).to_csv

      csv.should match('CSV')
      csv.should match('Raid Main')
      csv.split(",").count.should == 11
    end
  end
end