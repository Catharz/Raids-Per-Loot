Given /^the following raid types:$/ do |raid_types|
  RaidType.create!(raid_types.hashes)
end

When /^I delete the (.+) raid type$/ do |name|
  raid_type = RaidType.find_by_name(name)
  visit raid_types_path
  within("#raid_type_#{raid_type.id}") do
    click_link 'Destroy'
  end
end

Then /^I should see the following raid types:$/ do |expected_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_table.diff!(table)
end

Then /^I should see the raid type named: (.+)$/ do |name|
  expect(page).to have_css('p#raid_type_name', text: name)
end

Then /^I should see raid counted is set to: (.+)$/ do |value|
  expect(page).to have_css('p#raid_counted', text: value)
end

Then /^I should see raid points are set to: (.*)$/ do |points|
  expect(page).to have_css('p#raid_points', text: points)
end

Then /^I should see loot counted is set to: (.+)$/ do |value|
  expect(page).to have_css('p#loot_counted', text: value)
end

Then /^I should see loot points are set to: (.*)$/ do |cost|
  expect(page).to have_css('p#loot_cost', text: cost)
end
