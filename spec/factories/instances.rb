FactoryGirl.define do
  factory :instance do |f|
    f.start_time DateTime.now
  end
end