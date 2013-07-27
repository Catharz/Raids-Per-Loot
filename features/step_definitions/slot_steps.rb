Given /^the following slots:$/ do |slots|
  Slot.create!(slots.hashes)
end

When /^I delete the (.+) slot$/ do |name|
  slot = Slot.find_by_name(name)
  visit slots_path
  within("tr#slot_#{slot.id}") do
    click_link 'Destroy'
  end
end

Then /^I should see the following slots:$/ do |expected_slots_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_slots_table.diff!(table)
end
