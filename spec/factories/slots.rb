FactoryGirl.define do
  sequence :slot_name do |n|
    "Slot #{n}"
  end

  factory :slot do |f|
    f.name { generate(:slot_name) }
  end
end
