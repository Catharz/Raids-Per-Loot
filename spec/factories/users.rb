FactoryGirl.define do
  sequence :user_name do |n|
    "User #{n}"
  end
  sequence :user_login do |n|
    "user_#{n}"
  end
  sequence :user_password do |n|
    "Password#{n}!?!"
  end
  sequence :user_password_confirmation do |n|
    "Password#{n}!?!"
  end
  sequence :user_email do |n|
    "user#{n}@example.com"
  end

  factory :user do |f|
    f.name { generate(:user_name) }
    f.login { generate(:user_login) }
    f.password { generate(:user_password) }
    f.password_confirmation { generate(:user_password_confirmation) }
    f.email { generate(:user_email) }
  end

  factory :invalid_user, parent: :user do |f|
    f.name nil
    f.login nil
    f.password nil
    f.password_confirmation nil
    f.email nil
  end
end
