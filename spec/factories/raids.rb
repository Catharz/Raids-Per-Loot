FactoryGirl.define do
  sequence :raid_date do |n|
    Date.parse('01/01/2012') + n.days
  end

  sequence :raid_id do |n|
    raid = FactoryGirl.create(:raid, raid_date: Date.parse('01/01/2012') + n.days)
    raid.id
  end

  factory :raid do |f|
    f.raid_date { generate(:raid_date) }
    f.raid_type { |a| a.association(:raid_type) }
  end
end
