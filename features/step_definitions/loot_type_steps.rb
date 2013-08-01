Before('@loot_types') do
  %w{Armour Jewellery Weapon}.each { |loot_type_name|
    LootType.create!(:name => loot_type_name)
  }
end

Given /^I have the following loot types:$/ do |loot_types|
  LootType.create!(loot_types.hashes)
end

Given /^I have a loot type named (.+)$/ do |loot_type|
  LootType.create!(:name => loot_type)
end

When /^I delete the (.+) loot type$/ do |name|
  loot_type = LootType.find_by_name(name)
  visit loot_types_path
  within("tr#loot_type_#{loot_type.id}") do
    click_link 'Destroy'
  end
end

Then /^I should see the following loot types:$/ do |expected_loot_types_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_loot_types_table.diff!(table)
end

When /^I change the default loot method of (.+) to (.+)$/ do |loot_type_name, default_loot_method|
  loot_type = LootType.find_or_create_by_name(loot_type_name)
  visit edit_loot_type_path(loot_type)
  select(default_loot_method, from: "loot_type_default_loot_method")
  click_button "Update Loot type"
end

When(/^the loot type items updater is run$/) do
  LootType.all.each { |loot_type| LootTypeItemsUpdater.perform(loot_type.id) }
end

Then /^I should see loot type named: (.+)$/ do |name|
  expect(page).to have_css('p', text: name)
end