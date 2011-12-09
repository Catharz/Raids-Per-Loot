require 'factory_helper'

Given /^I have a mob named (.+) from (.+)$/ do |mob, zone|
  FactoryHelper.give_me_mob(zone, mob)
end

Given /^the following mobs:$/ do |mobs|
  mobs.hashes.each do |this_mob|
    zone = FactoryHelper.give_me_zone(this_mob['zone_name'])
    this_mob.delete('zone_name')
    mob = Mob.create!(this_mob)
    mob.zones = [zone]
    mob.save!
    zone.mobs = [mob]
    zone.save!
  end
  Mob.all
end

When /^I delete the (\d+)(?:st|nd|rd|th) mob$/ do |pos|
  visit mobs_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following mobs:$/ do |expected_mobs_table|
  expected_mobs_table.diff!(tableish('table tr', 'td,th'))
end
