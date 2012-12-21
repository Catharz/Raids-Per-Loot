When /^I have a (.+) raid at "(.+)"$/ do |zone_name, raid_time|
  FactoryHelper.give_me_instance(zone_name, raid_time)
end

Given /^the following instances:$/ do |instances|
  prog = RaidType.find_or_create_by_name('Progression')
  instances.hashes.each do |instance|
    zone = Zone.find_or_create_by_name(instance[:zone])
    raid = Raid.find_or_create_by_raid_date_and_raid_type_id(instance[:start_time], prog.id)
    Instance.create!(raid_id: raid.id, zone_id: zone.id, start_time: instance[:start_time])
  end
end

When /^I delete the (\d+)(?:st|nd|rd|th) instance$/ do |pos|
  visit instances_path
  within("table#instancesTable tbody tr:nth-child(#{pos.to_i})") do
    click_link "Destroy"
  end
end

Then /^I should see the following instances:$/ do |expected_instances_table|
  rows = find("table#instancesTable").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip } }
  expected_instances_table.diff!(table)
end

When /^I select (.+) as the instance's Zone$/ do |zone_name|
  select(zone_name, :from => "instance_zone_id")
end

When /^I select "([^"]*)" as the instance's Raid$/ do |raid_date|
  select raid_date, :from => 'instance_raid_id'
end
