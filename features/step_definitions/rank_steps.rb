Before('@ranks') do
  ['Main', 'Raid Alternate', 'General Alternate', 'Non-Member', 'Associate'].each do |rank_name|
    Rank.create(:name => rank_name)
  end
end

Given /^the following ranks:$/ do |ranks|
  Rank.create!(ranks.hashes)
end

When /^I delete the (.+) rank$/ do |name|
  rank = Rank.find_by_name(name)
  visit ranks_path
  within("tr#rank_#{rank.id}") do
    click_link 'Destroy'
  end
end

Then /^I should see the following ranks:$/ do |expected_ranks_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_ranks_table.diff!(table)
end
