require 'spec_helper'

describe Archetype do
  describe "archetype" do
    before(:each) do
      @grand_parent = FactoryGirl.create(:archetype, :name => 'Grand Parent')
      @parent = FactoryGirl.create(:archetype, :name => 'Parent', :parent_id => @grand_parent.id)
      @child = FactoryGirl.create(:archetype, :name => 'Child', :parent_id => @parent.id)
    end

    it "child root should be the top level" do
      @child.root.should == @grand_parent
    end

    it "parent root should be the top level" do
      @parent.root.should == @grand_parent
    end

    it "grand parent root should be the top level" do
      @grand_parent.root.should == @grand_parent
    end

    it "lists the root for every archetype" do
      root_list = Archetype.root_list

      root_list['Child'].should == 'Grand Parent'
      root_list['Parent'].should == 'Grand Parent'
      root_list['Grand Parent'].should == 'Grand Parent'
    end
  end
end
