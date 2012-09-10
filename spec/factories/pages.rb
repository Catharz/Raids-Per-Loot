FactoryGirl.define do
  factory :page do |f|
    f.name 'Page'
    f.title 'Page'
    f.navlabel 'Page'
    f.body '.'
    f.position 0
    f.admin false
  end
end