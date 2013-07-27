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