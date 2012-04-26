FactoryGirl.define do
  factory :user do |f|
    f.name "Freddy Krueger"
    f.login "freddyishere"
    f.password "password"
    f.email "whoever@wherever.com"
  end
end
