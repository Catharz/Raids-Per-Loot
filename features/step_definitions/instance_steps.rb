When /^I have a (.+) raid at "(.+)"$/ do |zone_name, raid_time|
  FactoryHelper.give_me_instance(zone_name, raid_time)
end