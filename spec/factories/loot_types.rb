FactoryGirl.define do
  sequence :loot_type_name do |n|
    "Loot Type #{n}"
  end

  sequence :loot_type_id do
    loot_type = FactoryGirl.create(:loot_type)
    loot_type.id
  end

  factory :loot_type do |f|
    f.name { generate(:loot_type_name) }
  end
end
