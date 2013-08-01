Given /^I have the following pages:$/ do |pages|
  Page.create!(pages.hashes)
end

When /^I delete the (.+) page$/ do |name|
  page = Page.find_by_name(name)
  visit pages_path
  within("tr#page_#{page.id}") do
    click_link "Destroy"
  end
end

Then /^I should see the following pages:$/ do |expected_pages_table|
  rows = find("table").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip} }
  expected_pages_table.diff!(table)
end

Then /^I should see the page named: (.+)$/ do |name|
  expect(page).to have_css('p', text: name)
end

Then /^I should see the page title: (.+)$/ do |title|
  expect(page).to have_css('p', text: title)
end

Then /^I should see the page navigation label: (.+)$/ do |label|
  expect(page).to have_css('p', text: label)
end

Then /^I should see the page body: (.*)$/ do |text|
  expect(page).to have_css('p', text: text)
end