class AddDefaultPages < ActiveRecord::Migration
  def self.up
    if Pages.all.empty?
      Page.create(:name => 'home', :title => 'Home', :navlabel => 'Home',
                  :position => 0, :admin => false, :parent => nil,
                  :redirect => false, :controller_name => nil, :action_name => nil,
                  :body => 'h1. Welcome to the raids per loot system!')
      Page.create(:name => 'links', :title => 'Links', :navlabel => 'Links',
                  :position => 1, :admin => false, :parent => nil, :redirect => true,
                  :controller_name => 'links', :action_name => 'index',
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
      Page.create(:name => 'ranks', :title => 'Player Ranks', :navlabel => 'Player ranks',
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
  end

  def self.down
  end
end
