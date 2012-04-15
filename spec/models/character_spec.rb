require 'spec_helper'

module CharacterSpecHelper
  def valid_character_attributes
    @fighter_archetype = Factory.create(:archetype, :name => 'Mage')
    @main_rank = Factory.create(:rank, :name => 'Main')
    @alternate_rank = Factory.create(:rank, :name => 'General Alternate')
    {:name => 'Fred',
     :archetype_id => @fighter_archetype.id,
     :char_type => 'm'}
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
  end
end