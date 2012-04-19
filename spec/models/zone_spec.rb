require 'spec_helper'

describe Zone do
  describe "progression" do
    it "should be a progression zone if raided less than 10 times and normal or lower difficulty" do
      normal = Factory.create(:difficulty, :name => 'Normal', :rating => 2)
      zone = Factory.create(:zone, :name => 'New Zone', :difficulty => normal)
      zone.stub!(:runs).and_return(9)

      zone.progression.should be_true
    end

    it "should be a progression zone if the zone is hard" do
      hard = Factory.create(:difficulty, :name => 'Hard', :rating => 3)
      zone = Factory.create(:zone, :name => 'Hard Zone', :difficulty => hard)
      zone.stub!(:runs).and_return(15)

      zone.progression.should be_true
    end

    it "should not be a progression zone if the zone is easy" do
      easy = Factory.create(:difficulty, :name => 'Easy', :rating => 1)
      zone = Factory.create(:zone, :name => 'Easy Zone', :difficulty => easy)
      zone.stub!(:runs).and_return(5)

      zone.progression.should be_false
    end

    it "should not be a progression zone if we have run it more than 20 times" do
      hard = Factory.create(:difficulty, :name => 'Hard', :rating => 3)
      zone = Factory.create(:zone, :name => 'Hard Zone', :difficulty => hard)
      zone.stub!(:runs).and_return(21)

      zone.progression.should be_false
    end
  end
end