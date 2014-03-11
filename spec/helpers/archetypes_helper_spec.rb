require 'spec_helper'
include ArchetypesHelper

describe ArchetypesHelper do
  fixtures :archetypes

  describe '#consolidate_archetypes' do
    it 'should return None when no archetypes are specified' do
      consolidate_archetypes([]).should eq 'None'
    end

    it "should return 'All Fighters' when all Fighters are specified" do
      bruiser = Archetype.find_by_name('Bruiser')
      monk = Archetype.find_by_name('Monk')
      paladin = Archetype.find_by_name('Paladin')
      shadowknight = Archetype.find_by_name('Shadowknight')
      berserker = Archetype.find_by_name('Berserker')
      guardian = Archetype.find_by_name('Guardian')

      consolidate_archetypes([bruiser, monk,
                              paladin, shadowknight,
                              berserker, guardian]).should eq "All Fighters"
    end

    it "should return 'All Brawlers' when all Brawlers are specified" do
      bruiser = Archetype.find_by_name('Bruiser')
      monk = Archetype.find_by_name('Monk')

      consolidate_archetypes([bruiser, monk]).should eq 'All Brawlers'
    end

    it 'should return individual archetypes when all are NOT specified'do
      bruiser = Archetype.find_by_name('Bruiser')
      monk = Archetype.find_by_name('Monk')
      beastlord = Archetype.find_by_name('Beastlord')

      consolidate_archetypes([bruiser, monk, beastlord]).
          should eq 'All Brawlers, Beastlord'
    end
  end
end
