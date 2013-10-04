FactoryGirl.define do
  factory :external_data do |f|
    f.data { {} }
  end

  factory :character_external_data, parent: :external_data do |f|
    f.character { |a| a.association(:character) }
  end

  factory :item_external_data, parent: :external_data do |f|
    f.item { |a| a.association(:item) }
  end
end