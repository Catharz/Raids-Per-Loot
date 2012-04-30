Given /^the following drops:$/ do |drops|
  drops.hashes.each do |drop|
    zone = Zone.find_by_name(drop[:zone_name])
    zone ||= Zone.create(:name => drop[:zone_name])

    mob = Mob.find_by_name_and_zone_id(drop[:mob_name], zone.id)
    mob ||= Mob.create(:name => drop[:mob_name], :zone_id => zone.id)

    loot_type = LootType.find_by_name(drop[:loot_type])
    loot_type ||= LootType.create(:name => drop[:loot_type])

    item = Item.find_by_name(drop[:item_name])
    item ||= Item.create(:name => drop[:item_name], :eq2_item_id => drop[:eq2_item_id], :loot_type => loot_type)

    character = Character.find_by_name(drop[:character_name])
    if character.nil?
      rank = Rank.find_or_create_by_name("Main")

      player = Player.find_by_name(drop[:character_name])
      player ||= Player.create(:name => drop[:character_name], :rank => rank)

      archetype = Archetype.find_or_create_by_name("Scout")

      character = Character.create(:name => drop[:character_name], :player => player, :archetype => archetype, :char_type => "m")
    end
    Drop.create!(
        :zone_id => zone.id,
        :mob_id => mob.id,
        :loot_type_id => loot_type.id,
        :item_id => item.id,
        :loot_method => "n",
        :character_id => character.id,
        :drop_time => drop[:drop_time])
  end
end

When /^I delete the (\d+)(?:st|nd|rd|th) drop$/ do |pos|
  visit drops_path
  within("table tbody tr:nth-child(#{pos.to_i})") do
    click_link "Destroy"
  end
end

Then /^I should see the following drops:$/ do |expected_drops_table|
  rows = find("table").all('tr')
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