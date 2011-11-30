Given /^the following drops:$/ do |drops|
  Drop.create!(drops.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) drop$/ do |pos|
  visit drops_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

When /^I assign the (\d+)(?:st|nd|rd|th) drop$/ do |pos|
  visit drops_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Assign"
  end
end

Then /^I should see the following drops:$/ do |expected_drops_table|
  expected_drops_table.diff!(tableish('table tr', 'td,th'))
end
