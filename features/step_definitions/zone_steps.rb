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
