FactoryGirl.define do
  sequence :archetype_name do |n|
    "Archetype #{n}"
  end

  sequence :archetype_id do |n|
    archetype = FactoryGirl.create(:archetype, name: "Archetype_#{n}")
    archetype.id
  end

  factory :archetype do |f|
    f.name { generate(:archetype_name) }
    f.parent_id 1
  end
end
