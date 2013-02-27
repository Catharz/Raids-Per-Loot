FactoryGirl.define do
  sequence :player_name do |n|
    "Player #{n}"
  end
  factory :player do |f|
    f.name { generate(:player_name) }
    f.rank { |a| a.association(:rank) }
  end
end