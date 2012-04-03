Given /I assign a drop named (.+) to (.+) from (.+) in (.+) at "(.+)"$/ do |item_name, character_name, mob_name, zone_name, drop_time|
  Drop.create!(:item_name => item_name, :character_name => character_name, :mob_name => mob_name, :zone_name => zone_name, :drop_time => drop_time)
  step "I assign the 1st drop"
end

Given /^the following drops:$/ do |drops|
  Drop.create!(drops.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) drop$/ do |pos|
  visit drops_path
  within("table tr:nth-child(#{pos.to_i})") do
    click_link "Destroy"
  end
end

When /^I assign the (\d+)(?:st|nd|rd|th) drop$/ do |pos|
  visit drops_path
  within("table tbody tr:nth-child(#{pos.to_i})") do
    click_link "Assign"
  end
end

Then /^I should see the following drops:$/ do |expected_drops_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_drops_table.diff!(table)
end
