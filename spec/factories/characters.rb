FactoryGirl.define do
  sequence :character_name do |n|
    "Character_#{n}"
  end

  sequence :character_id do
    character = FactoryGirl.create(:character)
    character.id
  end

  factory :character do |f|
    f.player_id  { generate(:player_id) }
    f.name { generate(:character_name) }
    f.char_type 'm'
    f.archetype_id { generate(:archetype_id) }
    f.external_data { |a| a.association(:external_data) }
    f.armour_count  0
    f.jewellery_count 0
    f.weapons_count 0
    f.adornments_count 0
    f.dislodgers_count 0
    f.mounts_count 10
    f.confirmed_rating nil
    f.confirmed_date nil
  end

  factory :invalid_character, parent: :character do |f|
    f.player nil
    f.name nil
    f.char_type 'f'
  end
end
