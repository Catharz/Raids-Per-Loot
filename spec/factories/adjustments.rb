FactoryGirl.define do
  factory :adjustment do |f|
    f.adjustment_date DateTime.now
    f.adjustment_type "MyString"
    f.amount 1
    f.reason "MyText"
    f.loot_type_id 1
    f.adjustable_id 1
    f.adjustable_type "MyString"
  end
end
