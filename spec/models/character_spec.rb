require 'spec_helper'

module CharacterSpecHelper
  def valid_character_attributes
    @fighter_archetype = Factory.create(:archetype, :name => 'Mage')
    @main_rank = Factory.create(:rank, :name => 'Main')
    @alternate_rank = Factory.create(:rank, :name => 'General Alternate')
    {:name => 'Fred',
     :archetype_id => @fighter_archetype.id}
  end
end

describe Character do
  include CharacterSpecHelper

  before(:each) do
    @character = Factory.create(:character, valid_character_attributes)
  end

  describe "character" do
    it "should calculate the loot rate with two decimal places" do
      num_raids = 37
      num_items = 5

      loot_rate = @character.calculate_loot_rate(num_raids, num_items)
      loot_rate.should == 6.17
    end

    it "should have a char_type that matches its last character type" do
      Factory.create(:character_type, :character => @character, :effective_date => Date.new - 90.days, :char_type => 'g')
      Factory.create(:character_type, :character => @character, :effective_date => Date.new - 60.days, :char_type => 'r')
      main_char = Factory.create(:character_type, :character => @character, :effective_date => Date.new - 30.days, :char_type => 'm')

      @character.char_type.should == main_char
    end
  end
end