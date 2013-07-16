FactoryGirl.define do
  sequence :comment_date do |n|
    Date.parse('2013-07-01') + n.days
  end

  factory :comment do |f|
    f.comment_date { generate(:comment_date) }
    f.commented_type  'Player'
    f.commented { |a| a.association :player }
    f.comment 'blah, blah, blah'
  end

  factory :invalid_comment, parent: :comment do |f|
    f.comment_date nil
    f.commented_type nil
    f.commented nil
    f.comment nil
  end
end
