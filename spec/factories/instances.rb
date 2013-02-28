FactoryGirl.define do
  sequence :start_time do |n|
    n.hours
  end

  factory :instance do |f|
    f.raid { |a| a.association(:raid, raid_date: Date.parse('01/01/2012')) }
    f.zone { |a| a.association(:zone) }
    f.start_time { Date.parse('01/01/2012')  + generate(:start_time) }
  end
end