FactoryGirl.define do
  factory :raid_type do |f|
    f.name "Raid Type"
    f.raid_counted true
    f.raid_points 1.5
    f.loot_counted true
    f.loot_cost 1.5
  end
end
