Before('@loot_types') do
  %w{Armour, Jewellery, Weapon}.each { |loot_type_name| Factory.create(:loot_type, :name => loot_type_name) }
end

Given /^I have a player named (.+)$/ do |player|
  Player.create(:name => player)
end

Given /^the following players:$/ do |players|
  Player.create!(players.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) player$/ do |pos|
  visit players_path
  within("table tbody tr:nth-child(#{pos.to_i})") do
    click_link "Destroy"
  end
end

Then /^I should see the following players:$/ do |expected_players_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_players_table.diff!(table)
end
