Given /^the following drops:$/ do |drops|
  drops.hashes.each do |drop|
    zone = Zone.find_by_name(drop[:zone])
    zone ||= Zone.create(:name => drop[:zone])

    prog = RaidType.find_or_create_by_name('Progression')

    raid = Raid.find_by_raid_date_and_raid_type_id(drop[:drop_time], prog.id)
    raid ||= Raid.create(raid_date: drop[:drop_time], raid_type: prog)

    instance = Instance.find_by_raid_id_and_start_time_and_zone_id(raid.id, drop[:drop_time], zone.id)
    instance ||= Instance.create(raid_id: raid.id, start_time: drop[:drop_time], zone_id: zone.id)

    mob = Mob.find_by_name_and_zone_id(drop[:mob], zone.id)
    mob ||= Mob.create(:name => drop[:mob], :zone_id => zone.id)

    default_loot_method = drop[:loot_type] == 'Trash' ? 't' : 'n'
    default_loot_method = case drop[:loot_type]
      when 'Weapon', 'Armour', 'Jewellery', 'Mount', 'Dislodger', 'Adornment'
        'n'
      when 'Spell', 'Trade Skill Component'
        'g'
      else
        't'
    end
    loot_type = LootType.find_by_name(drop[:loot_type])
    loot_type ||= LootType.create(:name => drop[:loot_type], :default_loot_method => default_loot_method)

    item = Item.find_by_name(drop[:item])
    item ||= Item.create(:name => drop[:item], :eq2_item_id => drop[:eq2_item_id], :loot_type => loot_type)

    rank = Rank.find_or_create_by_name("Main")
    player = Player.find_by_name(drop[:character])
    player ||= Player.create(:name => drop[:character], :rank => rank)

    archetype = Archetype.find_or_create_by_name("Scout")
    character = Character.find_by_name(drop[:character])
    character ||= Character.create(:name => drop[:character], :player => player, :archetype => archetype, :char_type => "m")

    Drop.create!(
        :instance_id => instance.id,
        :zone_id => zone.id,
        :mob_id => mob.id,
        :loot_type_id => loot_type.id,
        :item_id => item.id,
        :loot_method => drop[:loot_method],
        :character_id => character.id,
        :drop_time => drop[:drop_time])
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
  select(loot_method, from: "drop_loot_method")
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

When /^I select "([^"]*)" as the drop's Raid$/ do |raid_date|
  select raid_date, :from => 'drop_raid_id'
end

When /^I view the drops page$/ do
  visit drops_path
end

When /^I view the invalid drops$/ do
  visit invalid_drops_path
end

When /^I view all the invalid drops$/ do
  visit "#{invalid_drops_path}?trash=true"
end

Then /^I should see the following invalid drops:$/ do |invalid_drops_table|
  rows = find("table#invalidDropsTable").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip } }
  invalid_drops_table.diff!(table)
end

When /^I select "([^"]*)" as the drop's Instance$/ do |instance_description|
  select instance_description, :from => "drop_instance_id"
end
