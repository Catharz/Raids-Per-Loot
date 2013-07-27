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
