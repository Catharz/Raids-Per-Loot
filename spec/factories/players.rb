FactoryGirl.define do
  sequence :player_name do |n|
    "Player #{n}"
  end

  factory :player do |f|
    f.name { generate(:player_name) }
    f.rank { |a| a.association(:rank) }
    f.active true
    f.raids_count 0
  end
end