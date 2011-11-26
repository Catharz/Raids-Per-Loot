class AddDefaultLinks < ActiveRecord::Migration
  def self.up
    if LinkCategory.all.empty?
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
  end

  def self.down
  end
end
