FactoryGirl.define do
  sequence :user_name do |n|
    "User #{n}"
  end
  sequence :user_email do |n|
    "user#{n}@example.com"
  end

  factory :user do |f|
    f.name { generate(:user_name) }
    f.email { generate(:user_email) }
  end

  factory :invalid_user, parent: :user do |f|
    f.name nil
    f.email nil
  end
end
