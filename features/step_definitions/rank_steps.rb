Given /^the following ranks:$/ do |ranks|
  Rank.create!(ranks.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) rank$/ do |pos|
  visit ranks_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following ranks:$/ do |expected_ranks_table|
  expected_ranks_table.diff!(tableish('table tr', 'td,th'))
end
