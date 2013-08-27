FactoryGirl.define do
  sequence :url do |n|
    "http://www.example#{n}.com"
  end
  sequence :title do |n|
    "Title #{n}"
  end


  factory :link do |f|
    f.url { generate(:url) }
    f.title { generate(:title) }
    f.description "Description"
  end
end