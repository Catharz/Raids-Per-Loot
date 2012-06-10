Given /^I have an archetype named (\w+)$/ do |archetype|
  Archetype.create(:name => archetype)
end

Given /^I have an archetype named (.+) with a parent named (.+)$/ do |child,parent|
  parent_archetype = Archetype.find_or_create_by_name(parent)
  child_archetype = Archetype.find_or_create_by_name(child)
  child_archetype.update_attribute(:parent, parent_archetype)
end

When /^I am editing the archetype named (.+)$/ do |archetype|
  edited_archetype = Archetype.find_by_name(archetype)
  visit "/archetypes/#{edited_archetype.id}/edit"
end

And /^I set the parent archetype to (\w+)$/ do |parent_archetype|
  select(parent_archetype, :from => "archetype_parent_id")
end

And /^I click (.+)$/ do |button|
  click_button(button)
end

Given /^I am creating a new archetype named (.+)$/ do |archetype_name|
  visit path_to "the new archetype page"
  fill_in("archetype_name", :with => archetype_name)
end

When /^I edit the (.+) archetype and set its parent to (.+)$/ do |child, parent|
  step "I am editing the archetype named #{child}"
  select(parent, :from => "archetype_parent_id")
end