class AddEq2Archetypes < ActiveRecord::Migration
  def self.create_top_classes
    if !Archetype.find_by_name('Fighter')
      Archetype.create(:name => 'Fighter')
    end
    if !Archetype.find_by_name('Mage')
      Archetype.create(:name => 'Mage')
    end
    if !Archetype.find_by_name('Priest')
      Archetype.create(:name => 'Priest')
    end
    if !Archetype.find_by_name('Scout')
      Archetype.create(:name => 'Scout')
    end
  end

  def self.create_fighters
    if !Archetype.find_by_name('Brawler')
      Archetype.create(:name => 'Brawler', :parent_class => Archetype.find_by_name('Fighter'))
    end
    if !Archetype.find_by_name('Crusader')
      Archetype.create(:name => 'Crusader', :parent_class => Archetype.find_by_name('Fighter'))
    end
    if !Archetype.find_by_name('Warrior')
      Archetype.create(:name => 'Warrior', :parent_class => Archetype.find_by_name('Fighter'))
    end

    create_brawlers()
    create_crusaders()
    create_warriors()
  end

  def self.create_brawlers
    if !Archetype.find_by_name('Bruiser')
      Archetype.create(:name => 'Bruiser', :parent_class => Archetype.find_by_name('Brawler'))
    end
    if !Archetype.find_by_name('Monk')
      Archetype.create(:name => 'Monk', :parent_class => Archetype.find_by_name('Brawler'))
    end
  end

  def self.create_crusaders
    if !Archetype.find_by_name('Paladin')
      Archetype.create(:name => 'Paladin', :parent_class => Archetype.find_by_name('Crusader'))
    end
    if !Archetype.find_by_name('Shadow Knight')
      Archetype.create(:name => 'Shadow Knight', :parent_class => Archetype.find_by_name('Crusader'))
    end
  end

  def self.create_warriors
    if !Archetype.find_by_name('Berserker')
      Archetype.create(:name => 'Berserker', :parent_class => Archetype.find_by_name('Warrior'))
    end
    if !Archetype.find_by_name('Guardian')
      Archetype.create(:name => 'Guardian', :parent_class => Archetype.find_by_name('Warrior'))
    end
  end

  def self.create_mages
    if !Archetype.find_by_name('Enchanter')
      Archetype.create(:name => 'Enchanter', :parent_class => Archetype.find_by_name('Mage'))
    end
    if !Archetype.find_by_name('Sorcerer')
      Archetype.create(:name => 'Sorcerer', :parent_class => Archetype.find_by_name('Mage'))
    end
    if !Archetype.find_by_name('Summoner')
      Archetype.create(:name => 'Summoner', :parent_class => Archetype.find_by_name('Mage'))
    end

    create_enchanters()
    create_sorcerers()
    create_summoners()
  end

  def self.create_enchanters
    if !Archetype.find_by_name('Coercer')
      Archetype.create(:name => 'Coercer', :parent_class => Archetype.find_by_name('Enchanter'))
    end
    if !Archetype.find_by_name('Illusionist')
      Archetype.create(:name => 'Illusionist', :parent_class => Archetype.find_by_name('Enchanter'))
    end
  end

  def self.create_sorcerers
    if !Archetype.find_by_name('Warlock')
      Archetype.create(:name => 'Warlock', :parent_class => Archetype.find_by_name('Sorcerer'))
    end
    if !Archetype.find_by_name('Wizard')
      Archetype.create(:name => 'Wizard', :parent_class => Archetype.find_by_name('Sorcerer'))
    end
  end

  def self.create_summoners
    if !Archetype.find_by_name('Conjuror')
      Archetype.create(:name => 'Conjuror', :parent_class => Archetype.find_by_name('Summoner'))
    end
    if !Archetype.find_by_name('Necromancer')
      Archetype.create(:name => 'Necromancer', :parent_class => Archetype.find_by_name('Summoner'))
    end
  end

  def self.create_priests
    if !Archetype.find_by_name('Cleric')
      Archetype.create(:name => 'Cleric', :parent_class => Archetype.find_by_name('Priest'))
    end
    if !Archetype.find_by_name('Druid')
      Archetype.create(:name => 'Druid', :parent_class => Archetype.find_by_name('Priest'))
    end
    if !Archetype.find_by_name('Shaman')
      Archetype.create(:name => 'Shaman', :parent_class => Archetype.find_by_name('Priest'))
    end

    create_clerics()
    create_druids()
    create_shamans()
  end

  def self.create_clerics
    if !Archetype.find_by_name('Inquisitor')
      Archetype.create(:name => 'Inquisitor', :parent_class => Archetype.find_by_name('Cleric'))
    end
    if !Archetype.find_by_name('Templar')
      Archetype.create(:name => 'Templar', :parent_class => Archetype.find_by_name('Cleric'))
    end
  end

  def self.create_druids
    if !Archetype.find_by_name('Fury')
      Archetype.create(:name => 'Fury', :parent_class => Archetype.find_by_name('Druid'))
    end
    if !Archetype.find_by_name('Warden')
      Archetype.create(:name => 'Warden', :parent_class => Archetype.find_by_name('Druid'))
    end
  end

  def self.create_shamans
    if !Archetype.find_by_name('Defiler')
      Archetype.create(:name => 'Defiler', :parent_class => Archetype.find_by_name('Shaman'))
    end
    if !Archetype.find_by_name('Mystic')
      Archetype.create(:name => 'Mystic', :parent_class => Archetype.find_by_name('Shaman'))
    end
  end

  def self.create_scouts
    if !Archetype.find_by_name('Bard')
      Archetype.create(:name => 'Bard', :parent_class => Archetype.find_by_name('Scout'))
    end
    if !Archetype.find_by_name('Predator')
      Archetype.create(:name => 'Predator', :parent_class => Archetype.find_by_name('Scout'))
    end
    if !Archetype.find_by_name('Rogue')
      Archetype.create(:name => 'Rogue', :parent_class => Archetype.find_by_name('Scout'))
    end

    create_bards()
    create_predators()
    create_rogues()
  end

  def self.create_bards
    if !Archetype.find_by_name('Dirge')
      Archetype.create(:name => 'Dirge', :parent_class => Archetype.find_by_name('Bard'))
    end
    if !Archetype.find_by_name('Troubador')
      Archetype.create(:name => 'Troubador', :parent_class => Archetype.find_by_name('Bard'))
    end
  end

  def self.create_predators
    if !Archetype.find_by_name('Assassin')
      Archetype.create(:name => 'Assassin', :parent_class => Archetype.find_by_name('Predator'))
    end
    if !Archetype.find_by_name('Ranger')
      Archetype.create(:name => 'Ranger', :parent_class => Archetype.find_by_name('Predator'))
    end
  end

  def self.create_rogues
    if !Archetype.find_by_name('Brigand')
      Archetype.create(:name => 'Brigand', :parent_class => Archetype.find_by_name('Rogue'))
    end
    if !Archetype.find_by_name('Swashbuckler')
      Archetype.create(:name => 'Swashbuckler', :parent_class => Archetype.find_by_name('Rogue'))
    end
  end

  def self.up
    create_top_classes()

    create_fighters()
    create_mages()
    create_priests()
    create_scouts()
  end

  def self.down
  end
end
