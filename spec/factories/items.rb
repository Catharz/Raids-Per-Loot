FactoryGirl.define do
  sequence :item_name do |n|
    "Item #{n}"
  end

  sequence :eq2_item_id do |n|
    "eq2_item_#{n}"
  end

  sequence :item_id do
    item = FactoryGirl.create(:item)
    item.id
  end

  factory :item do |f|
    f.name { generate(:item_name) }
    f.eq2_item_id { generate(:eq2_item_id) }
    f.loot_type { |a| a.association(:loot_type) }
    f.info_url 'http://lootdb.com'
  end
end
