FactoryGirl.define do
  factory :raid do |f|
    f.raid_date Date.new
    f.raid_type_id 1
  end
end