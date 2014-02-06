FactoryGirl.define do
  sequence :loot_type_name do |n|
    "Loot Type #{n}"
  end

  factory :loot_type do |f|
    f.name { generate(:loot_type_name) }
  end
end
