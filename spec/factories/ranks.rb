FactoryGirl.define do
  sequence :rank_name do |n|
    "Rank #{n}"
  end

  sequence :rank_id do |n|
    rank = FactoryGirl.create(:rank, name: "Rank_#{n}")
    rank.id
  end

  factory :rank do |f|
    f.name { generate(:rank_name) }
  end
end
