FactoryGirl.define do
  factory :version do |f|
    f.item_id 1
    f.item_type 'Player'
    f.event 'update'
    f.whodunnit 'Me'
    f.object { |a| a.association(:player).to_yaml }
  end
end
