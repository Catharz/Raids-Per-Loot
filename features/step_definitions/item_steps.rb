Given /^I have an item named (.+) with id (.+)$/ do |item, item_id|
  Item.create!(:name => item, :eq2_item_id => item_id)
end

Given /^the following items:$/ do |items|
  Item.create!(items.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) item$/ do |pos|
  visit items_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following items:$/ do |expected_items_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_items_table.diff!(table)
end
