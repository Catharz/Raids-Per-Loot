FactoryGirl.define do
  sequence :raid_date do |n|
    Date.parse('01/01/2012') + n.days
  end

  factory :raid do |f|
    f.raid_date { generate(:raid_date) }
    f.raid_type { |a| a.association(:raid_type) }
  end
end