Given /^I have a (.+) character named (.+)$/ do |rank, character|
  case rank
    when "Main" then
      char_type = "m"
      player_name = character
    when "Raid Alternate" then "r"
      char_type = "r"
      player_name = "#{character} Raid Alternate"
    else
      char_type = "g"
      player_name = "#{character} General Alternate"
  end
  rank = Rank.create(:name => rank)
  player = Player.create(:name => player_name, :rank_id => rank.id)
  Character.create(:name => character, :char_type => char_type, :player_id => player.id)
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
