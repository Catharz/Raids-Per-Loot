FactoryGirl.define do
  sequence :log_line do |n|
    "This is Log line No. #{n}"
  end

  factory :drop do |f|
    f.instance { |a| a.association(:instance) }
    f.zone { |a| a.association(:zone) }
    f.mob { |a| a.association(:mob) }
    f.character  { |a| a.association(:character) }
    f.item { |a| a.association(:item) }
    f.loot_type { |a| a.association(:loot_type) }
    f.loot_method 'n'
    f.drop_time { |a| a.association(:instance).start_time }
    f.log_line { generate(:log_line) }
    f.chat { 'blah, blah, blah' }
  end
end