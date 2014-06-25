FactoryGirl.define do
  sequence :start_time do |n|
    n.hours
  end

  sequence :instance_id do
    instance = FactoryGirl.create(:instance)
    instance.id
  end

  factory :instance do |f|
    f.raid_id { generate(:raid_id) }
    f.zone_id { generate(:zone_id) }
    f.start_time { raid_date + generate(:start_time) }
  end

  factory :invalid_instance, parent: :instance do |f|
    f.raid nil
    f.zone nil
    f.start_time nil
  end
end
