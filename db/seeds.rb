# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

def create_default_users
  if !User.find_by_login('admin')
    User.create(:login => 'admin', :name => 'Admin User', :email => 'admin@sample.com',
                :password => 'changeme', :password_confirmation => 'changeme')
  end
  if !User.find_by_login('guest')
    User.create(:login => 'guest', :name => 'Guest User', :email => 'guest@sample.com',
                :password => 'changeme', :password_confirmation => 'changeme')
  end
end

def create_default_archetypes
  create_fighter_archetypes()
  create_mage_archetypes()
  create_priest_archetypes()
  create_scout_archetypes()
end


def create_default_slots
  @slots = ['Head', 'Chest', 'Shoulders', 'Forearms', 'Legs', 'Hands', 'Feet',
            'Neck', 'Ear', 'Finger', 'Wrist', 'Charm', 'Ranged', 'Primary', 'Secondary']
  @slots.each do |slot|
    if !Slot.find_by_name(slot)
      Slot.create(:name => slot)
    end
  end
end

def create_default_pages
  Page.create(:name => 'home', :title => 'Home', :navlabel => 'Home',
              :position => 0, :admin => false, :parent => nil,
              :redirect => false, :controller_name => nil, :action_name => nil,
              :body => 'h1. Welcome to the raids per loot system!')
  Page.create(:name => 'links', :title => 'Links', :navlabel => 'Links',
              :position => 1, :admin => false, :parent => nil, :redirect => true,
              :controller_name => 'links', :action_name => 'list',
              :body => '.')
  Page.create(:name => 'raids', :title => 'Raids', :navlabel => 'Raids',
              :position => 2, :admin => false, :parent => nil,
              :redirect => false, :controller_name => nil, :action_name => nil,
              :body => '.')
  Page.create(:name => 'players', :title => 'Players', :navlabel => 'Players',
              :position => 3, :admin => false, :parent => nil,
              :redirect => false, :controller_name => nil, :action_name => nil,
              :body => '.')
  Page.create(:name => 'drops', :title => 'Drops', :navlabel => 'Drops',
              :position => 4, :admin => false, :parent => nil,
              :redirect => false, :controller_name => nil, :action_name => nil,
              :body => '.')

  admin_page = Page.create!(:name => 'admin', :title => 'Site Admin', :navlabel => 'Site Admin',
                            :position => 5, :admin => true, :parent => nil,
                            :redirect => false, :controller_name => nil, :action_name => nil,
                            :body => 'Here are the various pages for administering this site.

Content allows you to modify, add and delete pages on this site.
You need to take care here so you don' 't break navigation to the admin functionality!

User Admin will allow you to maintain users.

Links and Link Categories allow you to maintain links to external sites.
')
  Page.create(:name => 'pages', :title => 'Content Management', :navlabel => 'Content',
              :position => 0, :admin => true, :parent => admin_page,
              :redirect => false, :controller_name => nil, :action_name => nil,
              :body => '.')
  Page.create(:name => 'users', :title => 'User Management', :navlabel => 'Users',
              :position => 1, :admin => true, :parent => admin_page,
              :redirect => false, :controller_name => nil, :action_name => nil,
              :body => '.')
  Page.create(:name => 'link_categories', :title => 'Link Categories', :navlabel => 'Link Categories',
              :position => 2, :admin => true, :parent => admin_page,
              :redirect => false, :controller_name => nil, :action_name => nil,
              :body => '.')
  Page.create(:name => 'links', :title => 'Links', :navlabel => 'Links',
              :position => 3, :admin => true, :parent => admin_page,
              :redirect => false, :controller_name => nil, :action_name => nil,
              :body => '.')

  loot_admin = Page.create!(:name => 'loot_admin', :title => 'Loot Admin', :navlabel => 'Loot Admin',
                            :position => 6, :admin => true, :parent => nil,
                            :redirect => false, :controller_name => nil, :action_name => nil,
                            :body => 'Here is where you can edit elements of the loot system.

Raid Zones is where you can enter the list of raid zones you will get loot from.
Mobs is where you can enter details of the named mobs that drop loot.
Player classes is for entering classes or archetypes that players belong to, and loot is for.
Player Ranks is where you enter player ranks, such as "Main", "Raid Alt" and "General Alt".
Players is obviously, where you enter players, their archetypes and ranks.
Loot Types is where you can categorize loot into Armour, Jewelery, etc, etc.
Loot Items is where you can enter the actual details of a particular item, what classes it is for and the slots it can go into.
Loot Slots is where you maintain the various places you can equip loot.')
  Page.create(:name => 'zones', :title => 'Raid Zones', :navlabel => 'Raid Zones',
              :position => 1, :admin => true, :parent => loot_admin,
              :redirect => false, :controller_name => nil, :action_name => nil,
              :body => '.')
  Page.create(:name => 'mobs', :title => 'Mobs', :navlabel => 'Mobs',
              :position => 2, :admin => true, :parent => loot_admin,
              :redirect => false, :controller_name => nil, :action_name => nil,
              :body => '.')
  Page.create(:name => 'archetypes', :title => 'Player Classes', :navlabel => 'Player Classes',
              :position => 3, :admin => true, :parent => loot_admin,
              :redirect => false, :controller_name => nil, :action_name => nil,
              :body => '.')
  Page.create(:name => 'ranks', :title => 'Player Ranks', :navlabel => 'Player Ranks',
              :position => 4, :admin => true, :parent => loot_admin,
              :redirect => false, :controller_name => nil, :action_name => nil,
              :body => '.')
  Page.create(:name => 'loot_types', :title => 'Loot Types', :navlabel => 'Loot Types',
              :position => 5, :admin => true, :parent => loot_admin,
              :redirect => false, :controller_name => nil, :action_name => nil,
              :body => '.')
  Page.create(:name => 'slots', :title => 'Loot Slots', :navlabel => 'Loot Slots',
              :position => 6, :admin => true, :parent => loot_admin,
              :redirect => false, :controller_name => nil, :action_name => nil,
              :body => '.')
  Page.create(:name => 'items', :title => 'Loot Items', :navlabel => 'Loot Items',
              :position => 7, :admin => true, :parent => loot_admin,
              :redirect => false, :controller_name => nil, :action_name => nil,
              :body => '.')
end

def create_default_loot_types
  @loot_types = ['Armour', 'Jewellery', 'Weapon', 'Adornment', 'Spell']
  @loot_types.each do |loot_type|
    if !LootType.find_by_name(loot_type)
      LootType.create(:name => loot_type)
    end
  end
end

def create_default_links
  eq2links = LinkCategory.create!(:title => 'EverQuest 2',
                                  :description => 'EverQuest 2 related web sites')
  southern_cross = Link.create!(:title => 'Southern Cross',
                                :url => 'http://southerncross.guildportal.com',
                                :description => 'Home page of the Southern Cross guild')
  loot_db = Link.create!(:title => 'LootDB',
                         :url => 'http://www.lootdb.com',
                         :description => 'EverQuest 2 Loot Database')
  eq2 = Link.create!(:title => 'EverQuest 2',
                     :url => 'http://www.everquest2.com',
                     :description => 'EverQuest Home Page')
  eq2wire = Link.create!(:title => 'EQ2 Wire',
                         :url => 'http://www.eq2wire.com',
                         :description => 'News Site for EverQuest 2')
  eq2links.links << southern_cross
  eq2links.links << loot_db
  eq2links.links << eq2
  eq2links.links << eq2wire


  rails_links = LinkCategory.create!(:title => 'Ruby on Rails',
                                     :description => 'Sites related to the technology used to build this site')
  ruby_on_rails = Link.create!(:title => 'Ruby on Rails',
                               :url => 'http://www.rubyonrails.org',
                               :description => 'The Ruby on Rails home page')
  heroku = Link.create!(:title => 'Heroku',
                        :url => 'http://www.heroku.com',
                        :description => 'Our web host')
  rails_oceania = Link.create!(:title => 'Ruby on Rails - Oceania Community',
                               :url => 'http://www.rubyonrails.com.au',
                               :description => 'A community of Ruby on Rails developers in Australia')
  building_web_apps = Link.create!(:title => 'Building Web Apps',
                                   :url => 'http://www.buildingwebapps.com',
                                   :description => 'Home of the Learning Rails podcast, which I used to create this system')
  rails_links.links << ruby_on_rails
  rails_links.links << heroku
  rails_links.links << rails_oceania
  rails_links.links << building_web_apps
end

# Character related stuff

def create_default_ranks
  Rank.create(:name => 'Main', :priority => 1)
  Rank.create(:name => 'Raid Alternate', :priority => 2)
  Rank.create(:name => 'General Alternate', :priority => 3)
  Rank.create(:name => 'Non-Member', :priority => 4)
end

def create_fighter_archetypes
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

def create_mage_archetypes
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

def create_priest_archetypes
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

def create_scout_archetypes
  scout = Archetype.create!(:name => 'Scout')

  Archetype.create!(:name => 'Beast Lord', :parent_class => scout)

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

def create_default_zones
  @zones = ["Kraytoc's Fortress of Rime",
            "Throne of Storms: Hall of Legends",
            "Temple of Rallos Zek: Foundations of Stone",
            "The Fortress of Drunder: Sullon's Spire",
            "The Fortress of Drunder: Tallon's Stronghold",
            "The Fortress of Drunder: Vallon's Tower",
            "Kraytoc's Fortress of Rime [Challenge]",
            "Throne of Storms: Hall of Legends [Challenge]",
            "Temple of Rallos Zek: Foundations of Stone [Challenge]",
            "The Fortress of Drunder: Sullon's Spire [Challenge]",
            "The Fortress of Drunder: Tallon's Stronghold [Challenge]",
            "The Fortress of Drunder: Vallon's Tower [Challenge]"]
  @zones.each do |zone|
    Zone.create!(:name => zone)
  end
end

def create_player(name, archetype, rank, main_character = nil)
  @rank_list ||= get_rank_list()
  @archetype_list ||= get_archetype_list()

  if main_character.nil?
    main_character_id = nil
  else
    @main_character_list ||= get_main_character_list

    if !@main_character_list.empty?
      main_character_id = @main_character_list[main_character]
    else
      main_character_id = nil
    end
  end

  Player.create!(:name => name,
                 :main_character_id => main_character_id,
                 :rank_id => @rank_list[rank],
                 :archetype_id => @archetype_list[archetype])
end

def create_main_fighters
  rank = "Main"
  create_player("Automatic", "Shadow Knight", rank)
  create_player("Catharz", "Monk", rank)
  create_player("Felixs", "Paladin", rank)
  create_player("Furiso", "Guardian", rank)
  create_player("Oduh", "Guardian", rank)
  create_player("Optiz", "Berserker", rank)
end

def create_main_mages
  rank = "Main"
  create_player("Beodan", "Illusionist", rank)
  create_player("Blooode", "Conjuror", rank)
  create_player("Coronary", "Conjuror", rank)
  create_player("Destruction", "Conjuror", rank)
  create_player("Droagon", "Wizard", rank)
  create_player("Fossil", "Conjuror", rank)
  create_player("Murdo", "Conjuror", rank)
  create_player("Playdra", "Wizard", rank)
  create_player("Ryhino", "Necromancer", rank)
  create_player("Sipporah", "Conjuror", rank)
  create_player("Spyce", "Coercer", rank)
  create_player("Tuvokk", "Conjuror", rank)
  create_player("Veranis", "Illusionist", rank)
end

def create_main_healers
  rank = "Main"
  create_player("Agaris", "Defiler", rank)
  create_player("Dalandra", "Defiler", rank)
  create_player("Fallaarr", "Inquisitor", rank)
  create_player("Jonuos", "Inquisitor", rank)
  create_player("Leddar", "Defiler", rank)
  create_player("Purzz", "Fury", rank)
  create_player("Scrubbz", "Fury", rank)
  create_player("Tearanin", "Warden", rank)
  create_player("Turgin", "Inquisitor", rank)
  create_player("Vandemen", "Inquisitor", rank)
end

def create_main_scouts
  rank = "Main"
  create_player("Arcz", "Dirge", rank)
  create_player("Chiteira", "Troubador", rank)
  create_player("Coltinator", "Ranger", rank)
  create_player("Larkosis", "Troubador", rank)
  create_player("Liandel", "Swashbuckler", rank)
  create_player("Mitia", "Assassin", rank)
  create_player("Piupiupa", "Assassin", rank)
  create_player("Porridge", "Assassin", rank)
  create_player("Rhaecula", "Dirge", rank)
  create_player("Scarletto", "Dirge", rank)
  create_player("Scrot", "Assassin", rank)
end

def create_fighter_alts
  rank = "Raid Alternate"
  create_player("Arcadias", "Berserker", rank, "Arcz")
  create_player("Bamm", "Bruiser", rank, "Coronary")
  create_player("Galwen", "Berserker", rank, "Spyce")
  create_player("Karsa", "Berserker", rank, "Murdo")
  create_player("Sormm", "Shadow Knight", rank, "Blooode")
  create_player("Spockula", "Paladin", rank, "Tuvokk")
  create_player("Toryl", "Berserker", rank, "Mitia")
end

def create_mage_alts
  rank = "Raid Alternate"
  create_player("Ashandra", "Conjuror", rank, "Dalandra")
  create_player("Bluff", "Coercer", rank, "Fossil")
  create_player("Hemir", "Conjuror", rank, "Scrot")
  create_player("Khalara", "Illusionist", rank, "Agaris")
  create_player("Sugarr", "Conjuror", rank, "Nakhari")
end

def create_priest_alts
  rank = "Raid Alternate"
  create_player("Brandaide", "Inquisitor", rank, "Droagon")
  create_player("Chucky", "Warden", rank, "Felixs")
  create_player("Larky", "Fury", rank, "Larkosis")
  create_player("Oriean", "Warden", rank, "Ryhino")
  create_player("Naganty", "Mystic", rank, "Tearanin")
end

def create_scout_alts
  rank = "Raid Alternate"
  create_player("Buffcat", "Dirge", rank, "Leddar")
  create_player("Cailus", "Dirge", rank, "Veranis")
  create_player("Colten", "Dirge", rank, "Coltinator")
  create_player("Fafhrd", "Troubador", rank, "Catharz")
  create_player("Fellhand", "Assassin", rank, "Furiso")
  create_player("Matrim", "Ranger", rank, "Sipporah")
  create_player("Minuet", "Dirge", rank, "Chiteira")
  create_player("Murillio", "Brigand", rank, "Turgin")
  create_player("Radda", "Assassin", rank, "Purzz")
  create_player("Therron", "Ranger", rank, "Beodan")
  create_player("Toshi", "Brigand", rank, "Porridge")
end

def get_rank_list
  rank_list = Hash.new
  Rank.all.each do |rank|
    rank_list[rank.name] = rank.id
  end
  rank_list
end

def get_archetype_list
  archetype_list = Hash.new
  Archetype.all.each do |archetype|
    archetype_list[archetype.name] = archetype.id
  end
  archetype_list
end

def get_main_character_list
  main_character_list = Hash.new
  Player.all.each do |player|
    main_character_list[player.name] ||= player.id if player.main_character_id.nil?
  end
  main_character_list
end

def create_default_players

  # Main Characters
  create_main_fighters
  create_main_mages
  create_main_healers
  create_main_scouts

  # Raid Alts
  create_fighter_alts
  create_mage_alts
  create_priest_alts
  create_scout_alts

  # TODO: General Alts

  # Non or Ex Members
  create_player("Laments", "Dirge", "Non-Member", nil)
end

create_default_users() if User.all.empty?
create_default_pages() if Page.all.empty?
create_default_links() if LinkCategory.all.empty?
create_default_archetypes() if Archetype.all.empty?
create_default_ranks() if Rank.all.empty?
create_default_slots() if Slot.all.empty?
create_default_loot_types() if LootType.all.empty?
create_default_zones() if Zone.all.empty?
create_default_players() if Player.all.empty?