FactoryGirl.define do
  factory :character do |f|
    f.player_id 1
    f.name "Character Name"
    f.char_type "g"
  end
end