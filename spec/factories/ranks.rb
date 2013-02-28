FactoryGirl.define do
  sequence :rank_name do |n|
    "Rank #{n}"
  end

  factory :rank do |f|
    f.name { generate(:rank_name) }
  end
end