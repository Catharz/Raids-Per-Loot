class AddEq2Archetypes < ActiveRecord::Migration
  def self.create_fighters
    fighter = Archetype.create!(:name => 'Fighter')

    brawler = Archetype.create!(:name => 'Brawler', :parent_class => fighter)
    brawler.sub_classes << Archetype.create!(:name => 'Bruiser', :parent_class => brawler)
    brawler.sub_classes << Archetype.create!(:name => 'Monk', :parent_class => brawler)

    crusader = Archetype.create!(:name => 'Crusader', :parent_class => fighter)
    crusader.sub_classes << Archetype.create!(:name => 'Paladin', :parent_class => crusader)
    crusader.sub_classes << Archetype.create!(:name => 'Shadow Knight', :parent_class => crusader)

    warrior = Archetype.create!(:name => 'Warrior', :parent_class => fighter)
    warrior.sub_classes << Archetype.create!(:name => 'Berserker', :parent_class => warrior)
    warrior.sub_classes << Archetype.create!(:name => 'Guardian', :parent_class => warrior)

    fighter.sub_classes << brawler
    fighter.sub_classes << crusader
    fighter.sub_classes << warrior
  end

  def self.create_mages
    mage = Archetype.create!(:name => 'Mage')

    enchanter = Archetype.create!(:name => 'Enchanter', :parent_class => mage)
    enchanter.sub_classes << Archetype.create!(:name => 'Coercer', :parent_class => enchanter)
    enchanter.sub_classes << Archetype.create!(:name => 'Illusionist', :parent_class => enchanter)

    sorceror = Archetype.create!(:name => 'Sorcerer', :parent_class => mage)
    sorceror.sub_classes << Archetype.create!(:name => 'Warlock', :parent_class => sorceror)
    sorceror.sub_classes << Archetype.create!(:name => 'Wizard', :parent_class => sorceror)

    summoner = Archetype.create!(:name => 'Summoner', :parent_class => mage)
    summoner.sub_classes << Archetype.create!(:name => 'Conjuror', :parent_class => summoner)
    summoner.sub_classes << Archetype.create!(:name => 'Necromancer', :parent_class => summoner)

    mage.sub_classes << enchanter
    mage.sub_classes << sorceror
    mage.sub_classes << summoner
  end

  def self.create_priests
    priest = Archetype.create!(:name => 'Priest')

    cleric = Archetype.create!(:name => 'Cleric', :parent_class => priest)
    cleric.sub_classes << Archetype.create!(:name => 'Inquisitor', :parent_class => cleric)
    cleric.sub_classes << Archetype.create!(:name => 'Templar', :parent_class => cleric)

    druid = Archetype.create!(:name => 'Druid', :parent_class => priest)
    druid.sub_classes << Archetype.create!(:name => 'Fury', :parent_class => druid)
    druid.sub_classes << Archetype.create!(:name => 'Warden', :parent_class => druid)

    shaman = Archetype.create!(:name => 'Shaman', :parent_class => priest)
    shaman.sub_classes << Archetype.create!(:name => 'Defiler', :parent_class => shaman)
    shaman.sub_classes << Archetype.create!(:name => 'Mystic', :parent_class => shaman)

    priest.sub_classes << cleric
    priest.sub_classes << druid
    priest.sub_classes << shaman
  end

  def self.create_scouts
    scout = Archetype.create!(:name => 'Scout')

    bard = Archetype.create!(:name => 'Bard', :parent_class => scout)
    bard.sub_classes << Archetype.create!(:name => 'Dirge', :parent_class => bard)
    bard.sub_classes << Archetype.create!(:name => 'Troubador', :parent_class => bard)

    predator = Archetype.create!(:name => 'Predator', :parent_class => scout)
    predator.sub_classes << Archetype.create!(:name => 'Assassin', :parent_class => predator)
    predator.sub_classes << Archetype.create!(:name => 'Ranger', :parent_class => predator)

    rogue = Archetype.create!(:name => 'Rogue', :parent_class => scout)
    rogue.sub_classes << Archetype.create!(:name => 'Brigand', :parent_class => rogue)
    rogue.sub_classes << Archetype.create!(:name => 'Swashbuckler', :parent_class => rogue)

    scout.sub_classes << bard
    scout.sub_classes << predator
    scout.sub_classes << rogue
  end

  def self.up
    if Archetype.all.empty?
      create_fighters()
      create_mages()
      create_priests()
      create_scouts()
    end
  end

  def self.down
  end
end
