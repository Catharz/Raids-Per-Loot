Given /^the following links:$/ do |links|
  Link.create!(links.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) link$/ do |pos|
  visit links_path
  within("table tr:nth-child(#{pos.to_i})") do
    click_link "Destroy"
  end
end

Then /^I should see the following links:$/ do |expected_links_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_links_table.diff!(table)
end
