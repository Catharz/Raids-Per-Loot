When /^I select "([^"]*)" as the player$/ do |player_name|
  step %{I have a Main player named #{player_name}}
  select player_name, from: 'player_raid[player_id]'
end

When /^I select "(.*?)" as the raid$/ do |raid_description|
  select raid_description, from: 'player_raid[raid_id]'
end

Given /^the following player_raids:$/ do |player_raids|
  player_raids.hashes.each do |player_raid|
    raid_date = player_raid['raid_date']
    raid_type = RaidType.find_or_create_by_name(player_raid['raid_type'])
    raid = Raid.find_or_create_by_raid_date_and_raid_type_id(raid_date, raid_type.id)
    main = Rank.find_or_create_by_name('Main')
    player = Player.find_or_create_by_name_and_rank_id(player_raid['player'], main.id)
    PlayerRaid.create!(player_id: player.id,
                      raid_id: raid.id,
                      signed_up: player_raid['signed_up'],
                      punctual: player_raid['punctual'],
                      status: player_raid['status']
    )
  end
end

When /^I delete the (\d+)(?:st|nd|rd|th) player_raid$/ do |pos|
  visit player_raids_path
  within("table tbody tr:nth-child(#{pos.to_i})") do
    click_link "Destroy"
  end
end

Then /^I should see the following player_raids:$/ do |expected|
  visit player_raids_path
  rows = find('table').all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip } }
  expected.diff!(table)
end