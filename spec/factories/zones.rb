FactoryGirl.define do
  sequence :zone_name do |n|
    "Zone #{n}"
  end

  sequence :zone_id do |n|
    zone = FactoryGirl.create(:zone, name: "Zone_#{n}")
    zone.id
  end

  factory :zone do |f|
    f.name { generate(:zone_name) }
    f.difficulty { |a| a.association(:difficulty) }
  end
end
