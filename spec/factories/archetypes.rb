FactoryGirl.define do
  sequence :archetype_name do |n|
    "Archetype #{n}"
  end

  factory :archetype do |f|
    f.name { generate(:archetype_name) }
    f.parent_id nil
  end
end
