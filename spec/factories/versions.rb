FactoryGirl.define do
  factory :version do |f|
    f.item { |a| a.association(:player) }
    f.event 'update'
    f.whodunnit 'Me'
    f.object { |a| a.association(:player).to_yaml }
  end
end