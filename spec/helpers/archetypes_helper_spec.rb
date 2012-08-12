require 'spec_helper'
include ArchetypesHelper

describe ArchetypesHelper do
  before(:each) do
    @fighter = FactoryGirl.create(:archetype, :name => 'Fighter')
    @brawler = @fighter.children.create(:name => 'Brawler', :parent => @fighter)
    @crusader = @fighter.children.create(:name => 'Crusader', :parent => @fighter)
    @warrior = @fighter.children.create(:name => 'Warrior', :parent => @fighter)

    @scout = FactoryGirl.create(:archetype, :name => 'Scout')
    @predator = @scout.children.create(:name => 'Predator')
  end

  describe "#consolidate_archetypes" do
    it "should return None when no archetypes are specified" do
      consolidate_archetypes([]).should eq "None"
    end

    it "should return 'All Fighters' when all Fighters are specified" do
      bruiser = @brawler.children.create(:name => 'Bruiser')
      monk = @brawler.children.create(:name => 'Monk')
      paladin = @crusader.children.create(:name => 'Paladin')
      shadowknight = @crusader.children.create(:name => 'Shadowknight')
      berserker = @warrior.children.create(:name => 'Berserker')
      guardian = @warrior.children.create(:name => 'Guardian')

      consolidate_archetypes([bruiser, monk, paladin, shadowknight, berserker, guardian]).should eq "All Fighters"
    end

    it "should return the supplied archetypes when all Fighters are NOT specified" do
      bruiser = @brawler.children.create(:name => 'Bruiser')
      monk = @brawler.children.create(:name => 'Monk')
      @predator.children.create(:name => 'Assassin')
      @predator.children.create(:name => 'Ranger')
      beastlord = @scout.children.create(:name => 'Beastlord')

      consolidate_archetypes([bruiser, monk, beastlord]).should eq "All Brawlers, Beastlord"
    end
  end
end