require 'factory_helper'

Given /^the following drops:$/ do |drops|
  drops.hashes.each do |hash|
    zone_name = hash['zone_name']
    mob_name = hash['mob_name']
    player_name = hash['player_name']
    item_name = hash['item_name']
    drop_time = DateTime.parse(hash['drop_time'])
    eq2_item_id = hash['eq2_item_id']

    zone = FactoryHelper.give_me_zone(hash['zone_name'])
    raid = FactoryHelper.give_me_raid(zone_name, drop_time)
    mob = FactoryHelper.give_me_mob(zone_name, mob_name)
    player = FactoryHelper.give_me_player(player_name)
    item = FactoryHelper.give_me_item(item_name, eq2_item_id)

    assert !zone.nil?
    assert !raid.nil?
    assert !mob.nil?
    assert !player.nil?
    assert !item.nil?
  end
  Drop.create!(drops.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) drop$/ do |pos|
  visit drops_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following drops:$/ do |expected_drops_table|
  expected_drops_table.diff!(tableish('table tr', 'td,th'))
end
