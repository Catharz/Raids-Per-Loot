FactoryGirl.define do
  factory :instance do |f|
    f.raid_id 1
    f.zone_id 1
    f.start_time DateTime.now
  end
end