Given /^the following archetypes:$/ do |archetypes|
  Archetype.create!(archetypes.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) archetype$/ do |pos|
  visit archetypes_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following archetypes:$/ do |expected_archetypes_table|
  expected_archetypes_table.diff!(tableish('table tr', 'td,th'))
end
