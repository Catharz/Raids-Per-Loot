Given /^I have a mob named (.+) from (.+)$/ do |mob_name, zone_name|
  easy = Difficulty.find_by_name('Easy') || FactoryGirl.create(:difficulty, name: 'Easy')
  zone = Zone.find_by_name(zone_name) || FactoryGirl.create(:zone, name: zone_name, difficulty: easy)
  Mob.find_by_name_and_zone_id(mob_name, zone.id) ||
      FactoryGirl.create(:mob, name: mob_name, zone: zone, difficulty: easy)
end

Given /^I have the following mobs:$/ do |mobs|
  mobs.hashes.each do |this_mob|
    difficulty = Difficulty.find_by_name(this_mob[:difficulty])
    zone = FactoryGirl.create(:zone, name: this_mob['zone_name'], difficulty: difficulty)
    this_mob.delete('zone_name')
    this_mob.delete('difficulty')
    FactoryGirl.create(:mob, this_mob.merge!(difficulty_id: difficulty.id, zone_id: zone.id))
  end
  Mob.all
end

When /^I delete the mob (.+)$/ do |name|
  mob = Mob.find_by_name(name)
  visit mobs_path
  within("tr#mob_#{mob.id}") do
    click_link 'Destroy'
  end
end

Then /^I should see the following mobs:$/ do |expected_mobs_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_mobs_table.diff!(table)
end

Then /^I should see the mob named: (.+)$/ do |name|
  expect(page).to have_css('p', text: name)
end

Then /^I should see the mob strategy: (.*)$/ do |strategy|
  expect(page).to have_css('p', text: strategy)
end

When(/^I enter (.+) as the mob's name$/) do |name|
  fill_in 'mob_name', with: name
end

When(/^I enter (.+) as the mob's alias$/) do |mob_alias|
  fill_in 'mob_alias', with: mob_alias
end

When(/^I select (.+) as the mob's zone$/) do |zone_name|
  select zone_name, from: 'mob_zone_id'
end

When(/^I enter (.+) as the mob's strategy$/) do |strategy|
  fill_in 'mob_strategy', with: strategy
end

When(/^I select (.+) as the mob's difficulty$/) do |difficulty|
  select difficulty, from: 'mob_difficulty_id'
end