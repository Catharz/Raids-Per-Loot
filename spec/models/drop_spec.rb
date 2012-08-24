require 'spec_helper'
require 'drop_spec_helper'

describe Drop do
  include DropSpecHelper

  before(:each) do
    @fighter = mock_model(Archetype, :name => 'Fighter')
    @scout = mock_model(Archetype, :name => 'Scout')
    @priest = mock_model(Archetype, :name => 'Priest')

    @player = mock_model(Player, :name => 'Fred')

    @raid_main = mock_model(Character, :name => 'Barny', :player => @player, :char_type => 'm', :archetype => @fighter)
    @raid_alt = mock_model(Character, :name => 'Betty', :player => @player, :char_type => 'r', :archetype => @scout)
    @general_alt = mock_model(Character, :name => 'Wilma', :player => @player, :char_type => 'g', :archetype => @priest)
  end

  describe "#loot_method_name" do
    it "should return 'Need' when loot_method is 'n'" do
      drop = Drop.new(:loot_method => 'n')

      drop.loot_method_name.should eq 'Need'
    end

    it "should return 'Trash' when loot_method is 't'" do
      drop = Drop.new(:loot_method => 't')

      drop.loot_method_name.should eq 'Trash'
    end

    it "should return 'Random' when loot_method is 'r'" do
      drop = Drop.new(:loot_method => 'r')

      drop.loot_method_name.should eq 'Random'
    end

    it "should return 'Guild Bank' when loot_method is 'g'" do
      drop = Drop.new(:loot_method => 'g')

      drop.loot_method_name.should eq 'Guild Bank'
    end

    it "should return 'Bid' when loot_method is 'b'" do
      drop = Drop.new(:loot_method => 'b')

      drop.loot_method_name.should eq 'Bid'
    end

    it "should return 'Unknown' when loot_method is invalid" do
      drop = Drop.new(:loot_method => '?')

      drop.loot_method_name.should eq 'Unknown'
    end

    it "should return 'Need' when loot_method is null" do
      drop = Drop.new

      drop.loot_method_name.should eq 'Need'
    end
  end

  describe "#correctly_assigned?" do
    it "should be true when item is won by need for raid main" do
      item = mock_model(Item, :loot_type => mock_model(LootType, :name => "Armour"))
      item.should_receive(:archetypes).and_return([@fighter, @scout])
      drop = Drop.new(:character => @raid_main, :item => item, :loot_method => 'n')
      @raid_main.should_receive(:main_character).and_return(@raid_main)

      drop.correctly_assigned?.should be_true
    end

    it "should be false when item is won by need for raid alternate" do
      item = mock_model(Item, :loot_type => mock_model(LootType, :name => "Armour"))
      drop = Drop.new(:character => @raid_alt, :item => item, :loot_method => 'n')
      @raid_alt.should_receive(:main_character).and_return(@raid_main)

      drop.correctly_assigned?.should be_false
    end

    it "should be false when item is won by need for general alternate" do
      item = mock_model(Item, :loot_type => mock_model(LootType, :name => "Armour"))
      drop = Drop.new(:character => @general_alt, :item => item, :loot_method => 'n')
      @general_alt.should_receive(:main_character).and_return(@raid_main)

      drop.correctly_assigned?.should be_false
    end

    it "should be true when item is won by random for raid main" do
      item = mock_model(Item, :loot_type => mock_model(LootType, :name => "Armour"))
      drop = Drop.new(:character => @raid_main, :item => item, :loot_method => 'r')
      @raid_main.should_receive(:raid_alternate).and_return(@raid_alt)

      drop.correctly_assigned?.should be_false
    end

    it "should be true when item is won by random for raid alternate" do
      item = mock_model(Item, :loot_type => mock_model(LootType, :name => "Armour"))
      item.should_receive(:archetypes).and_return([@scout])
      drop = Drop.new(:character => @raid_alt, :item => item, :loot_method => 'r')
      @raid_alt.should_receive(:raid_alternate).and_return(@raid_alt)

      drop.correctly_assigned?.should be_true
    end

    it "should be false when item is won by random for general alternate" do
      item = mock_model(Item, :loot_type => mock_model(LootType, :name => "Armour"))
      drop = Drop.new(:character => @general_alt, :item => item, :loot_method => 'r')
      @general_alt.should_receive(:raid_alternate).and_return(@raid_alt)

      drop.correctly_assigned?.should be_false
    end

    it "should be true when item is won as trash and item is trash" do
      item = mock_model(Item, :loot_type => mock_model(LootType, :name => "Trash", :default_loot_method => 't'))
      drop = Drop.new(:character => @raid_main, :item => item, :loot_method => 't')

      drop.correctly_assigned?.should be_true
    end

    it "should be false when item is won by need and item is trash" do
      item = mock_model(Item, :loot_type => mock_model(LootType, :name => "Trash", :default_loot_method => 't'))
      drop = Drop.new(:character => @raid_main, :item => item, :loot_method => 'n')

      drop.correctly_assigned?.should be_false
    end

    it "should be false when item is won by random and item is trash" do
      item = mock_model(Item, :loot_type => mock_model(LootType, :name => "Trash", :default_loot_method => 't'))
      drop = Drop.new(:character => @raid_main, :item => item, :loot_method => 'r')

      drop.correctly_assigned?.should be_false
    end

    it "should be false when item is won by bid and item is trash" do
      item = mock_model(Item, :loot_type => mock_model(LootType, :name => "Trash", :default_loot_method => 't'))
      drop = Drop.new(:character => @raid_main, :item => item, :loot_method => 'b')

      drop.correctly_assigned?.should be_false
    end
  end
end