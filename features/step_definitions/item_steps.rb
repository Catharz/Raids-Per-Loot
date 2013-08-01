Given /^I have a (.+) item named (.+) with id (.+)$/ do |loot_type_name, item, item_id|
  loot_type = LootType.find_or_create_by_name(loot_type_name)
  Item.create!(:name => item, :eq2_item_id => item_id, :loot_type_id => loot_type.id)
end

Given /^the following items:$/ do |items|
  Item.create!(items.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) item$/ do |pos|
  visit items_path
  within("table tr:nth-child(#{pos.to_i})") do
    page.evaluate_script('window.confirm = function() { return true; }')
    click_link "Destroy"
  end
end

Then /^I should see the following items:$/ do |expected_items_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_items_table.diff!(table)
end

Then /^I should see the item called: (.+)$/ do |item_name|
  expect(page).to have_css('p', text: item_name)
end

Then /^I should see the item id: (.+)$/ do |item_id|
  expect(page).to have_css('p', text: item_id)
end

Then /^I should see the item url: (.+)$/ do |url|
  expect(page).to have_css('p', text: url)
end