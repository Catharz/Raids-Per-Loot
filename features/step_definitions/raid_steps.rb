Given /^I have a (.+) raid at "(.+)"$/ do |zone_name, raid_time|
  FactoryHelper.give_me_raid(zone_name, DateTime.parse(raid_time))
end

Given /^the following raids:$/ do |raids|
  raids.hashes.each do |this_raid|
    zone = Zone.find_by_name(this_raid['zone_name'])
    if !zone
      zone = Zone.create!(:name => this_raid['zone_name'])
    end
    this_raid.delete('zone_name')
    this_raid['zone_id'] = zone.id
  end
  Raid.create!(raids.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) raid$/ do |pos|
  visit raids_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following raids:$/ do |expected_raids_table|
  expected_raids_table.diff!(tableish('table tr', 'td,th'))
end
