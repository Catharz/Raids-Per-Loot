FactoryGirl.define do
  sequence :player_name do |n|
    "Player #{n}"
  end

  sequence :player_id do |n|
    player = FactoryGirl.create(:player, name: "Player_#{n}")
    player.id
  end

  factory :player do |f|
    f.name { generate(:player_name) }
    f.rank_id { generate(:rank_id) }
    f.active true
    f.raids_count 0
  end
end
