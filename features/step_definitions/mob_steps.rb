require 'factory_helper'

Given /^I have a mob named (.+) from (.+)$/ do |mob, zone|
  FactoryHelper.give_me_mob(zone, mob, 'Easy')
end

Given /^the following mobs:$/ do |mobs|
  mobs.hashes.each do |this_mob|
    difficulty = Difficulty.find_by_name(this_mob[:difficulty])
    zone = FactoryHelper.give_me_zone(this_mob['zone_name'], difficulty.name)
    this_mob.delete('zone_name')
    this_mob.delete('difficulty')
    mob = Mob.create!(this_mob)
    mob.difficulty = difficulty
    mob.zone = zone
    mob.save!
  end
  Mob.all
end

When /^I delete the (\d+)(?:st|nd|rd|th) mob$/ do |pos|
  visit mobs_path
  within("table tr:nth-child(#{pos.to_i})") do
    click_link "Destroy"
  end
end

Then /^I should see the following mobs:$/ do |expected_mobs_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_mobs_table.diff!(table)
end
