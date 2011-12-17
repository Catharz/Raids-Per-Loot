Given /^the following loot_types:$/ do |loot_types|
  LootType.create!(loot_types.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) loot_type$/ do |pos|
  visit loot_types_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following loot_types:$/ do |expected_loot_types_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_loot_types_table.diff!(table)
end
