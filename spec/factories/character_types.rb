FactoryGirl.define do
  factory :character_type do |f|
    f.character { |a| a.association(:character) }
    f.char_type 'm'
    f.effective_date Date.parse('01/01/2012')
    f.normal_penalty 0
    f.progression_penalty 0
  end

  factory :invalid_character_type, parent: :character_type do |f|
    f.character nil
    f.char_type 'f'
    f.effective_date nil
    f.normal_penalty nil
    f.progression_penalty nil
  end
end