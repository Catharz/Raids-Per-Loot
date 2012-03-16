Given /^the following slots:$/ do |slots|
  Slot.create!(slots.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) slot$/ do |pos|
  visit slots_path
  within("table tr:nth-child(#{pos.to_i})") do
    click_link "Destroy"
  end
end

Then /^I should see the following slots:$/ do |expected_slots_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_slots_table.diff!(table)
end
