Given /^I have a player named (.+)$/ do |player|
  main = Rank.find_or_create_by_name('Main')
  Player.create(:name => player, :rank => main) unless Player.exists?(:name => player)
end

Given /^the following players:$/ do |players|
  main = Rank.find_or_create_by_name('Main')
  players.hashes.each do |player|
    player[:rank_id] = main.id
  end
  Player.create!(players.hashes)
end

When /^I delete the player named (.+)$/ do |name|
  player = Player.find_by_name(name)
  visit players_path
  within("#player_#{player.id}") do
    click_link 'Destroy'
  end
end

Then /^I should see the following players:$/ do |expected_players_table|
  visit players_path
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip } }
  expected_players_table.diff!(table)
end

Given /^the following player attendance:$/ do |all_attendance|
  main = Rank.find_or_create_by_name('Main')
  prog = RaidType.create(name: 'Progression')
  all_attendance.hashes.each do |attendance|
    player = Player.find_by_name(attendance[:player])
    player ||= Player.create(:name => attendance[:player], :rank => main)

    archetype = Archetype.find_or_create_by_name(attendance[:archetype])
    character = Character.find_by_name(attendance[:character])
    character ||= Character.create(:name => attendance[:character], :archetype_id => archetype.id, :player_id => player.id, :char_type => "m")

    raid = Raid.find_or_create_by_raid_date_and_raid_type_id(attendance[:raid_date], prog.id)
    PlayerRaid.create(player: player, raid: raid)
    instances = 1..attendance[:instances].to_i
    instances.to_a.each do |n|
      zone = Zone.find_or_create_by_name("Raid Zone #{n}")
      start_time = raid.raid_date + (n - 1).hours + 20.hours
      instance = Instance.find_by_start_time_and_zone_id(start_time, zone.id)
      instance ||= Instance.create(:raid_id => raid.id, :start_time => start_time, :zone_id => zone.id)

      unless CharacterInstance.exists?(:instance_id => instance.id, :character_id => character.id)
        CharacterInstance.create(:instance_id => instance.id, :character_id => character.id)
      end
    end
  end
end

Given /^I have a (.+) player named (.+)$/ do |rank_name, player_name|
  player = Player.find_by_name(player_name)
  if player.nil?
    rank = Rank.find_or_create_by_name(rank_name)
    Player.create(:name => player_name, :rank_id => rank.id)
  end
end

When /^I view the players page for (.+)$/ do |player_name|
  player = Player.find_by_name(player_name)
  visit player_path player
end

When(/^I enter (.*) as the player's name$/) do |player_name|
  fill_in 'player_name', with: player_name
end

When(/^I select (.*) as the player's rank$/) do |rank_name|
  select rank_name, from: 'player_rank_id'
end

Then /^I should see the player named: (.+)$/ do |name|
  expect(page).to have_css('p', text: name)
end

Then /^I should see the player rank: (.+)$/ do |rank|
  expect(page).to have_css('p', text: rank)
end