Given /^I have a zone named (.+)$/ do |zone|
  easy = Difficulty.find_by_name('Easy')
  Zone.create(:name => zone, :difficulty => easy) unless Zone.exists?(:name => zone)
end

Given /^the following zones:$/ do |zones|
  zones.hashes.each do |this_zone|
    difficulty = Difficulty.find_by_name(this_zone[:difficulty])
    this_zone.delete('difficulty')
    zone = Zone.create!(this_zone)
    zone.difficulty = difficulty
    zone.save!
  end
  Zone.all
end

When /^I delete the (.+) zone$/ do |name|
  zone = Zone.find_by_name(name)
  visit zones_path
  within("tr#zone_#{zone.id}") do
    click_link 'Destroy'
  end
end

Then /^I should see the following zones:$/ do |expected_zones_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_zones_table.diff!(table)
end
