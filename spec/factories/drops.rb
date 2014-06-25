FactoryGirl.define do
  sequence :log_line do |n|
    "This is Log line No. #{n}"
  end

  factory :drop do |f|
    f.instance_id { generate(:instance_id) }
    f.zone_id { generate(:zone_id) }
    f.mob_id { generate(:mob_id) }
    f.character_id { generate(:character_id) }
    f.item_id { generate(:item_id) }
    f.loot_type_id { generate(:loot_type_id) }
    f.loot_method 'n'
    f.drop_time DateTime.now
    f.log_line { generate(:log_line) }
    f.chat { 'blah, blah, blah' }
  end
end
