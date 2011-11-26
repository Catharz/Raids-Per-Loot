Given /^the following link_categories:$/ do |link_categories|
  LinkCategory.create!(link_categories.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) link_category$/ do |pos|
  visit link_categories_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following link_categories:$/ do |expected_link_categories_table|
  expected_link_categories_table.diff!(tableish('table tr', 'td,th'))
end
