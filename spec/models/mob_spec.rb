require 'spec_helper'

describe Mob do
  describe "progression" do
    it "should be a progression mob if killed less than 10 times and normal or lower difficulty" do
      normal = Factory.create(:difficulty, :name => 'Normal', :rating => 2)
      mob = Factory.create(:mob, :name => 'New Mob', :difficulty => normal)
      mob.stub!(:kills).and_return(9)

      mob.progression.should be_true
    end

    it "should be a progression mob if mob is hard to kill" do
      hard = Factory.create(:difficulty, :name => 'Hard', :rating => 3)
      mob = Factory.create(:mob, :name => 'Hard Mob', :difficulty => hard)
      mob.stub!(:kills).and_return(15)

      mob.progression.should be_true
    end

    it "should not be a progression mob if mob is easy to kill" do
      easy = Factory.create(:difficulty, :name => 'Easy', :rating => 1)
      mob = Factory.create(:mob, :name => 'Easy Mob', :difficulty => easy)
      mob.stub!(:kills).and_return(5)

      mob.progression.should be_false
    end

    it "should not be a progression mob if mob is killed more than 20 times" do
      hard = Factory.create(:difficulty, :name => 'Hard', :rating => 3)
      mob = Factory.create(:mob, :name => 'Hard Mob', :difficulty => hard)
      mob.stub!(:kills).and_return(21)

      mob.progression.should be_false
    end
  end
end