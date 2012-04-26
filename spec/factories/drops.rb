FactoryGirl.define do
  factory :drop do |f|
    f.zone_name "Wherever"
    f.mob_name "Whoever"
    f.character_name "Character"
    f.item_name "Whatever"
    f.eq2_item_id "123456789"
    f.drop_time DateTime.now
  end
end