Before('@difficulty') do
  [{:name => 'Easy', :rating => 1}, {:name => 'Normal', :rating => 2}, {:name => 'Hard', :rating => 3}].each { |difficulty|
    Factory.create(:difficulty, difficulty)
  }
end