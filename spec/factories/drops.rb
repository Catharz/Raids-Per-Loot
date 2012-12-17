FactoryGirl.define do
  factory :drop do |f|
    f.instance_id 1
    f.zone_id 1
    f.mob_id 1
    f.character_id 1
    f.item_id 1
    f.loot_method 'n'
    f.drop_time DateTime.now
  end
end