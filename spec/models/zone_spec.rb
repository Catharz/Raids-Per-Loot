require 'spec_helper'

describe Zone do
  describe 'progression' do
    it 'should be a progression zone if raided less than 10 times and normal or lower difficulty' do
      normal = FactoryGirl.create(:difficulty, :name => 'Normal', :rating => 2)
      zone = FactoryGirl.create(:zone, :name => 'New Zone', :difficulty => normal)
      zone.stub!(:runs).and_return(9)

      zone.progression.should be_true
      zone.is_progression?.should eq 'Yes'
    end

    it 'should be a progression zone if the zone is hard' do
      hard = FactoryGirl.create(:difficulty, :name => 'Hard', :rating => 3)
      zone = FactoryGirl.create(:zone, :name => 'Hard Zone', :difficulty => hard)
      zone.stub!(:runs).and_return(15)

      zone.progression.should be_true
      zone.is_progression?.should eq 'Yes'
    end

    it 'should not be a progression zone if the zone is easy' do
      easy = FactoryGirl.create(:difficulty, :name => 'Easy', :rating => 1)
      zone = FactoryGirl.create(:zone, :name => 'Easy Zone', :difficulty => easy)
      zone.stub!(:runs).and_return(5)

      zone.progression.should be_false
      zone.is_progression?.should eq 'No'
    end

    it 'should not be a progression zone if we have run it more than 20 times' do
      hard = FactoryGirl.create(:difficulty, :name => 'Hard', :rating => 3)
      zone = FactoryGirl.create(:zone, :name => 'Hard Zone', :difficulty => hard)
      zone.stub!(:runs).and_return(21)

      zone.progression.should be_false
      zone.is_progression?.should eq 'No'
    end
  end

  describe 'difficulty_name' do
    it 'should show the difficulty name when set' do
      hard = FactoryGirl.create(:difficulty, :name => 'Hard', :rating => 3)
      zone = FactoryGirl.create(:zone, :name => 'Hard Zone', :difficulty => hard)

      zone.difficulty_name.should eq 'Hard'
    end
  end
end