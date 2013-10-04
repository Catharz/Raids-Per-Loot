FactoryGirl.define do
  factory :adjustment do |f|
    f.adjustment_date Date.civil(2011, 12, 25)
    f.adjustment_type 'Raids'
    f.amount 1
    f.reason 'My Reason'
    f.adjustable { |a| a.association(:player) }
  end
end
