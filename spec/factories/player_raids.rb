FactoryGirl.define do
  factory :player_raid do |f|
    f.player { |a| a.association(:player) }
    f.raid { |a| a.association(:raid) }
    f.signed_up true
    f.punctual true
    f.status 'a'
  end

  factory :invalid_player_raid, parent: :player_raid do |f|
    f.player_id nil
    f.raid_id nil
    f.signed_up nil
    f.punctual nil
    f.status 'invalid'
  end
end