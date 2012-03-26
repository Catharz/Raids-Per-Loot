Factory.define :user do |f|
  f.name "Freddy Krueger"
  f.login "freddyishere"
  f.password "password"
  f.email "whoever@wherever.com"
end

Factory.define :archetype do |f|
  f.name "Archetype Name"
end

Factory.define :difficulty do |f|
  f.name "Easy"
  f.rating 5
end

Factory.define :drop do |f|
  f.zone_name "Wherever"
  f.mob_name "Whoever"
  f.player_name "Player"
  f.item_name "Whatever"
  f.eq2_item_id "123456789"
  f.drop_time DateTime.now
end

Factory.define :instance do |f|
  f.start_time DateTime.now
  f.end_time DateTime.now + 2.hours
end

Factory.define :item do |f|
  f.name "Whatever"
  f.eq2_item_id "123456789"
  f.info_url "http://lootdb.com"
end

Factory.define :link do |f|
  f.url "http://www.wherever.com"
  f.title "Title"
  f.description "Description"
end

Factory.define :link_category do |f|
  f.title "Whatever"
  f.description "Description of Whatever"
end

Factory.define :loot_type do |f|
  f.name "Whatever"
  f.show_on_player_list false
end

Factory.define :mob do |f|
  f.name "Whoever"
end

Factory.define :player do |f|
  f.name "Whoever"
end

Factory.define :raid do |f|
  f.raid_date Date.new
end

Factory.define :zone do |f|
  f.name "Wherever"
end