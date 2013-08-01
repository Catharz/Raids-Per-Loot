Given /^I have the following link categories:$/ do |link_categories|
  LinkCategory.create!(link_categories.hashes)
end

When /^I delete the link category (.+)$/ do |link_category_name|
  link_category = LinkCategory.find_by_title(link_category_name)
  visit link_categories_path
  within("tr#link_category_#{link_category.id}") do
    click_link 'Destroy'
  end
end

Then /^I should see the following link categories:$/ do |expected_link_categories_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_link_categories_table.diff!(table)
end

Then /^I should see the link category titled: (.+)$/ do |title|
  expect(page).to have_css('p', text: title)
end

Then /^I should see the link category description: (.+)$/ do |description|
  expect(page).to have_css('p', text: description)
end