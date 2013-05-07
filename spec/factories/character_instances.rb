FactoryGirl.define do
  factory :character_instance do |f|
    f.character_id 1
    f.instance_id 1
  end

  factory :invalid_character_instance, parent: :character_instance do |f|
    f.character_id nil
    f.instance_id nil
  end
end