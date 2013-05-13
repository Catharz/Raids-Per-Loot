FactoryGirl.define do
  sequence :character_name do |n|
    "Character #{n}"
  end

  factory :character do |f|
    f.player  { |a| a.association(:player) }
    f.name { generate(:character_name) }
    f.char_type 'm'
    f.archetype { |a| a.association(:archetype) }
  end

  factory :invalid_character, parent: :character do |f|
    f.player nil
    f.name nil
    f.char_type 'f'
  end
end