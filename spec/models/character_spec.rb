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

    context "#archetype_name" do
      it "should show the archetype name when the archetype is valid" do
        mage = FactoryGirl.create(:character, valid_character_attributes.merge!(:name => 'mage'))

        mage.archetype_name.should eq 'Mage'
      end

      it "should have an archetype name of Unknown when the archetype is not valid" do
        unknown = Character.new

        unknown.archetype_name.should eq 'Unknown'
      end
    end

    context "#archetype_root" do
      it "should show the root archetype name when it has one" do
        fighter = FactoryGirl.create(:archetype, name: 'Fighter')
        brawler = FactoryGirl.create(:archetype, name: 'Brawler', parent_id: fighter.id)
        character = FactoryGirl.create(:character, valid_character_attributes.merge!(name: 'brawler', archetype_id: brawler.id))

        character.archetype_root.should eq 'Fighter'
      end

      it "should show Unknown if it does not have an archetype" do
        unknown = Character.new

        unknown.archetype_root.should eq 'Unknown'
      end
    end
  end
end