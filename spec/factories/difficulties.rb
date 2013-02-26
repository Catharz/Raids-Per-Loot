FactoryGirl.define do
  factory :difficulty do |f|
    f.name "Easy"
    f.rating 5
  end

  factory :invalid_difficulty, parent: :difficulty do |f|
    f.name nil
    f.rating nil
  end
end