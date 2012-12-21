Given /^the following raid types:$/ do |raid_types|
  RaidType.create!(raid_types.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) raid type$/ do |pos|
  visit raid_types_path
  within("table tr:nth-child(#{pos.to_i})") do
    click_link "Destroy"
  end
end

Then /^I should see the following raid types:$/ do |expected_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_table.diff!(table)
end