FactoryGirl.define do
  sequence :mob_name do |n|
    "Mob #{n}"
  end

  sequence :mob_id do
    mob = FactoryGirl.create(:mob)
    mob.id
  end

  factory :mob do |f|
    f.name { generate(:mob_name) }
    f.zone { |a| a.association(:zone) }
    f.difficulty { |a| a.association(:difficulty) }
  end

  factory :invalid_mob, parent: :mob do |f|
    f.name nil
  end
end
