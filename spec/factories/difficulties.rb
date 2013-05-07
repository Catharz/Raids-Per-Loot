FactoryGirl.define do
  sequence :difficulty_name do |n|
    "Difficulty #{n}"
  end
  sequence :rating do |n|
    n
  end

  factory :difficulty do |f|
    f.name { generate(:difficulty_name) }
    f.rating { generate(:rating) }
  end

  factory :invalid_difficulty, parent: :difficulty do |f|
    f.name nil
    f.rating nil
  end
end