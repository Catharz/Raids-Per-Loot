# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

def create_default_users
  unless User.find_by_login('admin')
    User.create(:login => 'admin', :name => 'Admin User', :email => 'admin@sample.com',
                :password => 'changeme', :password_confirmation => 'changeme')
  end
  unless User.find_by_login('guest')
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
  @slots = %w{Head Chest Shoulders Forearms Legs Hands Feet Neck Ear Finger Wrist Charm Ranged Primary Secondary}
  @slots.each do |slot|
    Slot.find_or_create_by_name(slot)
  end
end

def create_default_pages
  # Home Page and Sub Pages
  home_page = Page.create(:name => 'home', :title => 'Home', :navlabel => 'Home',
                          :position => 0, :admin => false, :redirect => false,
                          :body => 'h1. Welcome to the raids per loot system!')
  home_page.children.create(:name => 'link_list', :title => 'Links', :navlabel => 'Links',
                            :position => 1, :admin => false, :redirect => true,
                            :controller_name => 'links', :action_name => 'list', :body => '.')

  # Raiding Page and Sub Pages
  raiding_page = Page.create(:name => 'raiding', :title => 'Raiding', :navlabel => 'Raiding',
                             :position => 1, :admin => false,
                             :body => 'This is the raiding section of the site')
  raiding_page.children.create(:name => 'raids', :title => 'Raids', :navlabel => 'Raids',
                               :position => 0, :admin => false, :body => '.')
  raiding_page.children.create(:name => 'instances', :title => 'Instances', :navlabel => 'Instances',
                               :position => 1, :admin => false, :body => '.')
  raiding_page.children.create(:name => 'zones', :title => 'Zones', :navlabel => 'Zones',
                               :position => 2, :admin => false, :body => '.')
  raiding_page.children.create(:name => 'mobs', :title => 'Mobs', :navlabel => 'Mobs',
                               :position => 3, :admin => false, :body => '.')
  raiding_page.children.create(:name => 'difficulties', :title => 'Difficulties', :navlabel => 'Difficulties',
                               :position => 4, :admin => true, :body => '.')

  # Players Page and Sub Pages
  players_page = Page.create(:name => 'players', :title => 'Characters', :navlabel => 'Characters',
                             :position => 2, :admin => false, :body => '.')
  players_page.children.create(:name => 'archetypes', :title => 'Classes', :navlabel => 'Classes',
                               :position => 0, :admin => true, :body => '.')
  players_page.children.create(:name => 'ranks', :title => 'Ranks', :navlabel => 'Ranks',
                               :position => 1, :admin => true, :body => '.')

  # Loot Page and Sub Pages
  loot_page = Page.create(:name => 'loot', :title => 'Loot', :navlabel => 'Loot',
                          :position => 3, :admin => false, :body => 'This is the loot section of the site')
  loot_page.children.create(:name => 'drops', :title => 'Drops', :navlabel => 'Drops',
                            :position => 0, :admin => false, :body => '.')
  loot_page.children.create(:name => 'items', :title => 'Items', :navlabel => 'Items',
                            :position => 1, :admin => false, :body => '.')
  loot_page.children.create(:name => 'slots', :title => 'Slots', :navlabel => 'Slots',
                            :position => 2, :admin => true, :body => '.')
  loot_page.children.create(:name => 'loot_types', :title => 'Types', :navlabel => 'Types',
                            :position => 3, :admin => true, :body => '.')

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
  @loot_types = %w{Armour Jewellery Weapon Adornment Spell}
  @loot_types.each do |loot_type|
    LootType.find_or_create_by_name(loot_type)
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
  rails_casts = Link.create(:title => 'Rails Casts',
                            :url => 'http://railscasts.com',
                            :description => 'Ryan Bates' ' Rails Casts')
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
  rails_links.links << rails_casts
  rails_links.links << building_web_apps
  rails_links.links << rails_oceania
  rails_links.links << heroku
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
  crusader.children.create(:name => 'Shadowknight')

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

  scout.children.create(:name => 'Beastlord')
end

def create_default_zones
  @zones = [{:name => "Kraytoc's Fortress of Rime", :difficulty => Difficulty.find_by_name('Easy')},
            {:name => "Throne of Storms: Hall of Legends", :difficulty => Difficulty.find_by_name('Easy')},
            {:name => "Temple of Rallos Zek: Foundations of Stone", :difficulty => Difficulty.find_by_name('Easy')},
            {:name => "The Fortress of Drunder: Sullon's Spire", :difficulty => Difficulty.find_by_name('Normal')},
            {:name => "The Fortress of Drunder: Tallon's Stronghold", :difficulty => Difficulty.find_by_name('Normal')},
            {:name => "The Fortress of Drunder: Vallon's Tower", :difficulty => Difficulty.find_by_name('Normal')},
            {:name => "Kraytoc's Fortress of Rime [Challenge]", :difficulty => Difficulty.find_by_name('Hard')},
            {:name => "Throne of Storms: Hall of Legends [Challenge]", :difficulty => Difficulty.find_by_name('Hard')},
            {:name => "Temple of Rallos Zek: Foundations of Stone [Challenge]", :difficulty => Difficulty.find_by_name('Hard')},
            {:name => "The Fortress of Drunder: Sullon's Spire [Challenge]", :difficulty => Difficulty.find_by_name('Hard')},
            {:name => "The Fortress of Drunder: Tallon's Stronghold [Challenge]", :difficulty => Difficulty.find_by_name('Hard')},
            {:name => "The Fortress of Drunder: Vallon's Tower [Challenge]", :difficulty => Difficulty.find_by_name('Hard')}]
  Zone.create!(@zones)
end

def create_default_difficulties
  @difficulties = [{:name => 'Easy', :rating => 1},
                   {:name => 'Normal', :rating => 2},
                   {:name => 'Hard', :rating => 3}]
  Difficulty.create!(@difficulties)
end

create_default_users() if User.all.empty?
create_default_pages() if Page.all.empty?
create_default_links() if LinkCategory.all.empty?
create_default_archetypes() if Archetype.all.empty?
create_default_ranks() if Rank.all.empty?
create_default_slots() if Slot.all.empty?
create_default_loot_types() if LootType.all.empty?
create_default_difficulties if Difficulty.all.empty?
create_default_zones() if Zone.all.empty?