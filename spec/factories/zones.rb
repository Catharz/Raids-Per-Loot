FactoryGirl.define do
  sequence :zone_name do |n|
    "Zone #{n}"
  end

  factory :zone do |f|
    f.name { generate(:zone_name) }
    end
end