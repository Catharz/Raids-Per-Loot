FactoryGirl.define do
  sequence :archetype_name do |n|
    "Archetype #{n}"
  end

  factory :archetype do |f|
    f.name { generate(:archetype_name) }
  end
end
