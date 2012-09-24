FactoryGirl.define do
  factory :player_raid do |f|
    f.player_id 1
    f.raid_id 1
    f.signed_up true
    f.punctual true
    f.status 'a'
  end
end