Given /^I have a (.+) character named (.+)$/ do |rank, character|
  case rank
    when "Main" then
      char_type = "m"
      player_name = character
    when "Raid Alternate" then
      "r"
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
  characters.hashes.each do |char|
    player = Player.find_or_initialize_by_name(char[:player])
    player.rank = Rank.find_or_create_by_name('Main')
    player.save

    char.delete 'player'
    char['player_id'] = player.id
    char['char_type'] ||= 'm'
  end
  Character.create!(characters.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) character$/ do |pos|
  visit characters_path
  within("table tbody tr:nth-child(#{pos.to_i})") do
    click_link "Destroy"
  end
end

When /^I view the character (.+)'s details$/ do |name|
  visit characters_path
  character = Character.find_by_name(name)
  within("table tbody") do
    click_link "char_#{character.id}_#{character.char_type}"
  end
end


Then /^I should see the following characters:$/ do |expected_characters_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip } }
  expected_characters_table.diff!(table)
end

When /^I select "([^"]*)" as the characters player$/ do |player_name|
  select(player_name, :from => "character_player_id")
end

When /^I enter "([^"]*)" as the characters name$/ do |name|
  fill_in("character_name", :with => name)
end

When /^I select "([^"]*)" as the characters class$/ do |archetype|
  select(archetype, :from => "character_archetype_id")
end

When /^I select "(.+)" as the character type$/ do |character_type|
  select(character_type, from: "character_char_type")
end

When /^I save the character$/ do
  click_button("btnCreate")
end

When /^I view the characters page for (.+)$/ do |character_name|
  character = Character.find_by_name(character_name)
  visit character_path character
end

When /^player (.+) has a (.+) character named (.+)$/ do |player_name, character_type, character_name|
  player = Player.find_by_name(player_name)
  unless player.nil?
    char_type =
        case character_type
          when "Main" then
            "m"
          when "Raid Alternate" then
            "r"
          else
            "g"
        end
    player.characters.create(:name => character_name, :char_type => char_type)
  end
end

Then(/^I should see the character named: (.*)$/) do |name|
  expect(page).to have_css('div#details p', text: name)
end

Then(/^I should see the character class: (.*)$/) do |class_name|
  expect(page).to have_css('div#details p', text: class_name)
end

Then(/^I should see the character type: (.+)$/) do |char_type|
  expect(page).to have_css('div#details p', text: char_type)
end