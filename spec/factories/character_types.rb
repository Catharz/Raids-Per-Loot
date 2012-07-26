FactoryGirl.define do
  factory :character_type do |f|
    f.character_id 1
    f.char_type "m"
    f.effective_date Date.new
    f.normal_penalty 0
    f.progression_penalty 0
  end
end