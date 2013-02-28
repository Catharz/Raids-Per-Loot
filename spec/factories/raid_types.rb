FactoryGirl.define do
  sequence :raid_type_name do |n|
    "Raid Type #{n}"
  end

  factory :raid_type do |f|
    f.name { generate(:raid_type_name) }
    f.raid_counted true
    f.raid_points 1.5
    f.loot_counted true
    f.loot_cost 1.5
  end
end
