Given /^I have the following links:$/ do |links|
  Link.create!(links.hashes)
end

When /^I delete the link to (.+)$/ do |url|
  url = Link.find_by_url(url)
  visit links_path
  within("tr#link_#{url.id}") do
    click_link 'Destroy'
  end
end

Then /^I should see the following links:$/ do |expected_links_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_links_table.diff!(table)
end

Then /^I should see the link url: (.+)$/ do |url|
  expect(page).to have_css('p', text: url)
end

Then /^I should see the link titled: (.+)$/ do |title|
  expect(page).to have_css('p', text: title)
end

Then /^I should see the link description: (.+)$/ do |description|
  expect(page).to have_css('p', text: description)
end