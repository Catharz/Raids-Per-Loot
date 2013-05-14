FactoryGirl.define do
  sequence :data do |n|
    {"value#{n}" => n}
  end

  factory :external_data do |f|
    f.data { generate(:data) }
  end

  factory :character_external_data, parent: :external_data do |f|
    f.character { |a| a.association(:character) }
  end

  factory :item_external_data, parent: :external_data do |f|
    f.item { |a| a.association(:item) }
  end
end