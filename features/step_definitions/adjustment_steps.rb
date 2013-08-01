When /^I select to adjust the (.+) named (.+)$/ do |entity_type, entity_name|
  step "I change the adjustable entity to #{entity_type}"
  step "I change the adjusted entity to #{entity_name}"
end

When /^I enter (.+) as the adjustment date$/ do |adjustment_date|
  fill_in 'adjustment[adjustment_date]', :with => adjustment_date
end

When /^I select (.+) as the adjustment type$/ do |adjustment_type|
  select adjustment_type, :from => 'adjustment_adjustment_type'
end

When /^I select (\d+) as the adjusted amount$/ do |amount|
  fill_in 'adjustment[amount]', :with => amount
end

When /^I save the adjustment$/ do
  click_button('Save')
end

When /^the following adjustments:$/ do |adjustments|
  adjustments.hashes.each do |adjustment|
    if adjustment[:adjusted].eql? "Player"
      adjustable = Player.find_by_name(adjustment[:name])
    else
      adjustable = Character.find_by_name(adjustment[:name])
    end
    adjustable.adjustments.create(
        :adjustment_date => adjustment[:date],
        :adjustment_type => adjustment[:type],
        :amount => adjustment[:amount])
  end
end

When /^I edit the (\d+)(?:st|nd|rd|th) adjustment for the Player named (.+)$/ do |pos, player_name|
  player = Player.find_by_name(player_name)
  visit player_adjustments_path(player)
  within("table tbody tr:nth-child(#{pos.to_i})") do
    click_link 'Edit'
  end
end

When /^I change the adjustable entity to (.+)$/ do |adjustable_entity|
  select adjustable_entity, :from => 'adjustment_adjustable_type'
end

When /^I change the adjusted entity to (.+)$/ do |entity_name|
  select entity_name, :from => 'adjustment_adjustable_id'
end