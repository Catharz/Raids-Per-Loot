FactoryGirl.define do
  sequence :start_time do |n|
    n.hours
  end

  factory :instance do |f|
    raid_date = Date.parse('01/01/2012')
    f.raid { |a| a.association(:raid, raid_date: raid_date) }
    f.zone { |a| a.association(:zone) }
    f.start_time { raid_date + generate(:start_time) }
  end

  factory :invalid_instance, parent: :instance do |f|
    f.raid nil
    f.zone nil
    f.start_time nil
  end
end