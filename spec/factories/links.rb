FactoryGirl.define do
  factory :link do |f|
    f.url "http://www.wherever.com"
    f.title "Title"
    f.description "Description"
  end
end