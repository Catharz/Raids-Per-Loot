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

    it "should give the char_type at a particular time" do
      character = FactoryGirl.create(:character, valid_character_attributes.merge!(:name => 'switching to main'))
      FactoryGirl.create(:character_type, :character_id => character.id, :char_type => 'g', :effective_date => Date.parse("01/01/2012"))
      FactoryGirl.create(:character_type, :character_id => character.id, :char_type => 'r', :effective_date => Date.parse("01/03/2012"))
      FactoryGirl.create(:character_type, :character_id => character.id, :char_type => 'm', :effective_date => Date.parse("01/06/2012"))

      character.rank_at_time(Date.parse("01/02/2012")).should eq 'g'
      character.rank_at_time(Date.parse("01/03/2012")).should eq 'r'
      character.rank_at_time(Date.parse("01/06/2012")).should eq 'm'
    end
  end
end