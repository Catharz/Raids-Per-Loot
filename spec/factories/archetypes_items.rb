FactoryGirl.define do
  factory :archetypes_item do |f|
    f.archetype { |a| a.association(:archetype) }
    f.item { |a| a.association(:item) }
  end
end
