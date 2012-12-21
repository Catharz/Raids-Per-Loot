Given /^the following raids:$/ do |raids|
  raid_type = RaidType.find_or_create_by_name('Progression')
  raids.hashes.each do |raid|
    Raid.create(raid_date: raid[:raid_date], raid_type: raid_type)
  end
end

When /^I delete the (\d+)(?:st|nd|rd|th) raid$/ do |pos|
  visit raids_path
  within("table tr:nth-child(#{pos.to_i})") do
    click_link "Destroy"
  end
end

Then /^I should see the following raids:$/ do |expected_raids_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_raids_table.diff!(table)
end

When /^I enter (\d+)\-(\d+)\-(\d+) as the raid date$/ do |year, month, day|
  fill_in "raid[raid_date]", :with => "#{year}-#{month}-#{day}"
end

When /^I have a raid on "([^"]*)"$/ do |raid_date|
  Raid.create!(raid_date: raid_date)
end

When /^I select (\w+) as the raid type$/ do |raid_type|
  select raid_type, from: "raid[raid_type_id]"
end