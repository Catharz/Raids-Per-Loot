Given(/^the following player characters:$/) do |player_characters|
  player_characters.hashes.each do |player_character|
    player = Player.find_by_name(player_character[:player])
    main = Rank.find_or_create_by_name('Main')
    player ||= Player.create(name: player_character[:player], rank_id: main.id)
    player.raids_count = player_character[:raids]
    player.active = player_character[:active] == 'yes'
    player.save

    archetype = Archetype.find_by_name(player_character[:class])

    character = player.characters.find_or_create_by_name(player_character[:character])
    character.char_type = player_character[:char_type]
    character.archetype = archetype
    character.armour_count = player_character[:armour]
    character.jewellery_count = player_character[:jewellery]
    character.weapons_count = player_character[:weapons]
    character.adornments_count = player_character[:adornments]
    character.dislodgers_count = player_character[:dislodgers]
    character.mounts_count = player_character[:mounts]
    character.save
  end
end

Then(/^I should see the following raid mains:$/) do |expected_loot_table|
  visit '/characters/loot'
  click_link 'Raid Mains'
  rows = find('div#charactersLootTable_m_wrapper').all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip } }
  expected_loot_table.diff!(table)
end

Then(/^I should see the following raid alternates:$/) do |expected_loot_table|
  visit '/characters/loot#raid_alts'
  click_link 'Raid Alts'
  rows = find('div#charactersLootTable_r_wrapper').all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip } }
  expected_loot_table.diff!(table)
end
