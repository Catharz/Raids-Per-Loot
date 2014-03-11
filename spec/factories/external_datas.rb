FactoryGirl.define do
  factory :external_data do |f|
    f.data { {} }
  end

  factory :character_external_data, parent: :external_data do |f|
    f.retrievable_id 1
    f.retrievable_type 'Character'
  end

  factory :item_external_data, parent: :external_data do |f|
    f.retrievable_id 1
    f.retrievable_type 'Item'
  end
end
