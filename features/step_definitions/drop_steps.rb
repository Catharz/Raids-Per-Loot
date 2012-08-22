Given /^the following drops:$/ do |drops|
  drops.hashes.each do |drop|
    zone = Zone.find_by_name(drop[:zone])
    zone ||= Zone.create(:name => drop[:zone])

    mob = Mob.find_by_name_and_zone_id(drop[:mob], zone.id)
    mob ||= Mob.create(:name => drop[:mob], :zone_id => zone.id)

    default_loot_method = drop[:loot_type] == "Trash" ? "t" : "n"
    loot_type = LootType.find_by_name(drop[:loot_type])
    loot_type ||= LootType.create(:name => drop[:loot_type], :default_loot_method => default_loot_method)

    item = Item.find_by_name(drop[:item])
    item ||= Item.create(:name => drop[:item], :eq2_item_id => drop[:eq2_item_id], :loot_type => loot_type)

    rank = Rank.find_or_create_by_name("Main")
    player = Player.find_by_name(drop[:player])
    player ||= Player.create(:name => drop[:player], :rank => rank)

    archetype = Archetype.find_or_create_by_name("Scout")
    character = Character.find_by_name(drop[:character])
    character ||= Character.create(:name => drop[:character], :player => player, :archetype => archetype, :char_type => "m")

    observer = DropObserver.instance
    drop = Drop.create!(
        :zone_id => zone.id,
        :mob_id => mob.id,
        :loot_type_id => loot_type.id,
        :item_id => item.id,
        :loot_method => drop[:loot_method],
        :character_id => character.id,
        :drop_time => drop[:drop_time])
    observer.after_save(drop)
  end
end

When /^I delete the (\d+)(?:st|nd|rd|th) drop$/ do |pos|
  visit drops_path
  within("table tbody tr:nth-child(#{pos.to_i})") do
    page.evaluate_script('window.confirm = function() { return true; }')
    click_link "Destroy"
  end
end

Then /^I should see the following drops:$/ do |expected_drops_table|
  rows = find("table#dropsTable").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip } }
  expected_drops_table.diff!(table)
end

Then /^I should see the following character|player drops:$/ do |expected_drops_table|
  rows = find("table#dropsTabTable").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip } }
  expected_drops_table.diff!(table)
end

When /^I select a loot method of (.+)$/ do |loot_method|
  choose case loot_method
           when "Need" then
             "need"
           when "Random" then
             "random"
           when "Bid" then
             "bid"
           else
             "trash"
         end
end

When /^I select (.+) as the Zone$/ do |zone_name|
  select(zone_name, :from => "drop_zone_id")
end

When /^I select (.+) as the Mob$/ do |mob_name|
  select(mob_name, :from => "drop_mob_id")
end

When /^I select (.+) as the Character$/ do |character_name|
  select(character_name, :from => "drop_character_id")
end

When /^I select (.+) as the Item$/ do |item_name|
  select(item_name, :from => "drop_item_id")
end

When /^I select (.+) as the Loot Type$/ do |loot_type|
  select(loot_type, :from => "drop_loot_type_id")
end

When /^I view the drops page$/ do
  visit drops_path
end

When /^I view the invalid drops page$/ do
  visit invalid_drops_path
end

Then /^I should see the following invalid drops:$/ do |invalid_drops_table|
  rows = find("table#invalidDropsTable").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip } }
  invalid_drops_table.diff!(table)
end