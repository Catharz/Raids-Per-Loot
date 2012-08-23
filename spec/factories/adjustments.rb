FactoryGirl.define do
  factory :adjustment do |f|
    f.adjustment_date Date.civil(2011, 12, 25)
    f.adjustment_type "MyString"
    f.amount 1
    f.reason "MyText"
    f.adjustable_id 1
    f.adjustable_type "MyString"
  end
end
