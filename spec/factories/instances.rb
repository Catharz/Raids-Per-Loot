FactoryGirl.define do
  factory :instance do |f|
    f.start_time DateTime.now
    f.end_time DateTime.now + 2.hours
  end
end