FactoryGirl.define do
  sequence :page_name do |n|
    "page_name_#{n}"
  end

  sequence :page_title do |n|
    "Page Title #{n}"
  end

  sequence :page_label do |n|
    "Page Label #{n}"
  end

  sequence :position do |n|
    n
  end

  factory :page do |f|
    f.name { generate(:page_name) }
    f.title { generate(:page_title) }
    f.navlabel { generate(:page_label) }
    f.body '.'
    f.position { generate(:position) }
    f.admin false
    f.parent_id nil
  end
end