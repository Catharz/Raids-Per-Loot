Before('@loot_types') do
  %w{Armour, Jewellery, Weapon}.each { |loot_type_name| Factory.create(:loot_type, :name => loot_type_name) }
end

Given /^I have a (.+) character named (.+)$/ do |rank, character|
  char_type = case rank when "Main" then "m" when "Raid Alternate" then "r" else "g" end
  Character.create(:name => character, :char_type => char_type)
end

Given /^the following characters:$/ do |characters|
  Character.create!(characters.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) character$/ do |pos|
  visit characters_path
  within("table tbody tr:nth-child(#{pos.to_i})") do
    click_link "Destroy"
  end
end

Then /^I should see the following characters:$/ do |expected_characters_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_characters_table.diff!(table)
end
