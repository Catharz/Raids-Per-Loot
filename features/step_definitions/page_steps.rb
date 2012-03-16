Given /^the following pages:$/ do |pages|
  Page.create!(pages.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) page$/ do |pos|
  visit pages_path
  within("table tr:nth-child(#{pos.to_i})") do
    click_link "Destroy"
  end
end

Then /^I should see the following pages:$/ do |expected_pages_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_pages_table.diff!(table)
end
