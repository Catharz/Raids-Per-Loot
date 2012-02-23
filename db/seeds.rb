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
  # Home Page and Sub Pages
  home_page = Page.create(:name => 'home', :title => 'Home', :navlabel => 'Home',
                          :position => 0, :admin => false, :redirect => false,
                          :body => 'h1. Welcome to the raids per loot system!')
  home_page.children.create(:name => 'links', :title => 'Links', :navlabel => 'Links',
                            :position => 0, :admin => false, :redirect => true,
                            :controller_name => 'links', :action_name => 'list', :body => '.')

  # Raiding Page and Sub Pages
  raiding_page = Page.create(:name => 'raiding', :title => 'Raiding', :navlabel => 'Raiding',
                             :position => 1, :admin => false,
                             :body => 'This is the raiding section of the site')
  raiding_page.children.create(:name => 'raids', :title => 'Raids', :navlabel => 'Raids',
                               :position => 0, :admin => false, :body => '.')
  raiding_page.children.create(:name => 'zones', :title => 'Zones', :navlabel => 'Zones',
                               :position => 1, :admin => false, :body => '.')
  raiding_page.children.create(:name => 'mobs', :title => 'Mobs', :navlabel => 'Mobs',
                               :position => 2, :admin => false, :body => '.')

  # Players Page and Sub Pages
  players_page = Page.create(:name => 'players_menu', :title => 'Players', :navlabel => 'Players',
                             :position => 2, :admin => false, :body => 'This is the players section of the site')
  players_page.children.create(:name => 'players', :title => 'Characters', :navlabel => 'Characters',
                               :position => 0, :admin => false, :body => '.')
  players_page.children.create(:name => 'archetypes', :title => 'Classes', :navlabel => 'Classes',
                               :position => 1, :admin => false, :body => '.')
  players_page.children.create(:name => 'ranks', :title => 'Ranks', :navlabel => 'Ranks',
                               :position => 2, :admin => false, :body => '.')

  # Loot Page and Sub Pages
  loot_page = Page.create(:name => 'loot', :title => 'Loot', :navlabel => 'Loot',
                          :position => 3, :admin => false, :body => 'This is the loot section of the site')
  loot_page.children.create(:name => 'drops', :title => 'Drops', :navlabel => 'Drops',
                            :position => 0, :admin => false, :body => '.')
  loot_page.children.create(:name => 'loot_types', :title => 'Types', :navlabel => 'Types',
                            :position => 1, :admin => false, :body => '.')
  loot_page.children.create(:name => 'slots', :title => 'Slots', :navlabel => 'Slots',
                            :position => 2, :admin => false, :body => '.')
  loot_page.children.create(:name => 'items', :title => 'Items', :navlabel => 'Items',
                            :position => 3, :admin => false, :body => '.')

  # Admin Page and Sub Pages
  admin_page = Page.create!(:name => 'admin', :title => 'Site Admin', :navlabel => 'Site Admin',
                            :position => 4, :admin => true, :body => 'This is the admin section of the site')
  admin_page.children.create(:name => 'pages', :title => 'Content Management', :navlabel => 'Content',
                             :position => 0, :admin => true, :body => '.')
  admin_page.children.create(:name => 'links', :title => 'Links', :navlabel => 'Links',
                             :position => 1, :admin => true, :body => '.')
  admin_page.children.create(:name => 'link_categories', :title => 'Link Categories', :navlabel => 'Link Categories',
                             :position => 2, :admin => true, :body => '.')
  admin_page.children.create(:name => 'users', :title => 'User Management', :navlabel => 'Users',
                             :position => 3, :admin => true, :body => '.')
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
  Rank.create(:name => 'Associate', :priority => 1)
  Rank.create(:name => 'Raid Alternate', :priority => 2)
  Rank.create(:name => 'General Alternate', :priority => 3)
  Rank.create(:name => 'Non-Member', :priority => 4)
end

def create_fighter_archetypes
  fighter = Archetype.create!(:name => 'Fighter')

  brawler = fighter.children.create(:name => 'Brawler')
  brawler.children.create(:name => 'Bruiser')
  brawler.children.create(:name => 'Monk')

  crusader = fighter.children.create(:name => 'Crusader')
  crusader.children.create(:name => 'Paladin')
  crusader.children.create(:name => 'Shadow Knight')

  warrior = fighter.children.create(:name => 'Warrior')
  warrior.children.create(:name => 'Berserker')
  warrior.children.create(:name => 'Guardian')
end

def create_mage_archetypes
  mage = Archetype.create!(:name => 'Mage')

  enchanter = mage.children.create(:name => 'Enchanter')
  enchanter.children.create(:name => 'Coercer')
  enchanter.children.create(:name => 'Illusionist')

  sorceror = mage.children.create(:name => 'Sorcerer')
  sorceror.children.create(:name => 'Warlock')
  sorceror.children.create(:name => 'Wizard')

  summoner = mage.children.create(:name => 'Summoner')
  summoner.children.create(:name => 'Conjuror')
  summoner.children.create(:name => 'Necromancer')
end

def create_priest_archetypes
  priest = Archetype.create!(:name => 'Priest')

  cleric = priest.children.create(:name => 'Cleric')
  cleric.children.create(:name => 'Inquisitor')
  cleric.children.create(:name => 'Templar')

  druid = priest.children.create(:name => 'Druid')
  druid.children.create(:name => 'Fury')
  druid.children.create(:name => 'Warden')

  shaman = priest.children.create(:name => 'Shaman')
  shaman.children.create(:name => 'Defiler')
  shaman.children.create(:name => 'Mystic')
end

def create_scout_archetypes
  scout = Archetype.create!(:name => 'Scout')

  bard = scout.children.create(:name => 'Bard')
  bard.children.create(:name => 'Dirge')
  bard.children.create(:name => 'Troubador')

  predator = scout.children.create(:name => 'Predator')
  predator.children.create(:name => 'Assassin')
  predator.children.create(:name => 'Ranger')

  rogue = scout.children.create(:name => 'Rogue')
  rogue.children.create(:name => 'Brigand')
  rogue.children.create(:name => 'Swashbuckler')

  scout.children.create(:name => 'Beast Lord')
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
  create_player("Rattso", "Necromancer", rank)
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
  create_player("Nakhari", "Templar", rank)
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