Given /^I have a zone named (.+)$/ do |zone|
  Zone.create(:name => zone) unless Zone.exists?(:name => zone)
end

Given /^the following zones:$/ do |zones|
  Zone.create!(zones.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) zone$/ do |pos|
  visit zones_path
  within("table tr:nth-child(#{pos.to_i})") do
    click_link "Destroy"
  end
end

Then /^I should see the following zones:$/ do |expected_zones_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_zones_table.diff!(table)
end
