Before('@ranks') do
  ranks = YAML.load_file File.join(Rails.root, 'spec', 'fixtures', 'archetypes.yml')
  ranks.each do |rank|
    Rank.create(rank[1])
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

Then /^I should see the rank named: (.+)$/ do |name|
  expect(page).to have_css('div.field span.data', text: name)
end

Then /^I should see the rank priority: (.+)$/ do |priority|
  expect(page).to have_css('div.field span.data', text: priority)
end

When(/^I enter (.+) as the rank name$/) do |name|
  fill_in 'rank_name', with: name
end

When(/^I enter (\d+) as the rank priority$/) do |priority|
  fill_in 'rank_priority', with: priority
end