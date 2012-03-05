require 'spec_helper'

describe Archetype do
  describe "archetype" do
    before(:each) do
      @grand_parent = Factory.create(:archetype, :name => 'Grand Parent')
      @parent = Factory.create(:archetype, :name => 'Parent', :parent_id => @grand_parent.id)
      @child = Factory.create(:archetype, :name => 'Child', :parent_id => @parent.id)
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
  end
end
