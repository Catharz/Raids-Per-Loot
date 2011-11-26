Given /^the following zones:$/ do |zones|
  Zone.create!(zones.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) zone$/ do |pos|
  visit zones_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following zones:$/ do |expected_zones_table|
  expected_zones_table.diff!(tableish('table tr', 'td,th'))
end
