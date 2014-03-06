FactoryGirl.define do
  sequence :provider_name do |n|
    "provider#{n}"
  end
  sequence :uid do |n|
    "000#{n}"
  end
  sequence :uname do |n|
    "User #{n}"
  end
  sequence :uemail do |n|
    "user#{n}@example.com"
  end

  factory :service do
    provider { generate(:provider_name) }
    uid { generate(:uid) }
    uname { generate(:uname) }
    uemail { generate(:uemail) }
  end
end
