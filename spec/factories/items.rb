FactoryGirl.define do
  factory :item do |f|
    f.name "Whatever"
    f.eq2_item_id "123456789"
    f.info_url "http://lootdb.com"
  end
end