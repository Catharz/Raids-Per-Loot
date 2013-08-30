When /^I have a (.+) raid at "(.+)"$/ do |zone_name, raid_time|
  zone = Zone.find_by_name(zone_name) || FactoryGirl.create(:zone, name: zone_name)
  raid = Raid.find_by_raid_date(Date.parse(raid_time)) || FactoryGirl.create(:raid, raid_date: Date.parse(raid_time))
  FactoryGirl.create(:instance, zone: zone, raid: raid, start_time: raid_time)
end

Given /^the following instances:$/ do |instances|
  prog = RaidType.find_or_create_by_name('Progression')
  instances.hashes.each do |instance|
    zone = Zone.find_or_create_by_name(instance[:zone])
    raid = Raid.find_or_create_by_raid_date_and_raid_type_id(instance[:start_time], prog.id)
    Instance.create!(raid_id: raid.id, zone_id: zone.id, start_time: instance[:start_time])
  end
end

When /^I delete the last instance in (.+)$/ do |zone_name|
  visit instances_path
  zone = Zone.find_by_name(zone_name)
  instance = Instance.where(zone_id: zone.id).last
  unless instance.nil?
    within("tr#instance_#{instance.id}") do
      click_link 'Destroy'
    end
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

Then /^I should see the start time: (.*)$/ do |start_time|
  expect(page).to have_css('p', text: start_time)
end