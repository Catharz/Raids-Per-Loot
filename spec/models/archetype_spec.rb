require 'spec_helper'

describe Archetype do
  describe 'archetype' do
    before(:each) do
      Archetype.delete_all
      @grand_parent = FactoryGirl.create(:archetype, name: 'Grand Parent')
      @parent = FactoryGirl.create(:archetype,
                                   name: 'Parent', parent_id: @grand_parent.id)
      @child = FactoryGirl.create(:archetype,
                                  name: 'Child', parent_id: @parent.id)
    end

    describe 'root' do
      it 'should have the grand parent as the root of child' do
        @child.root.should == @grand_parent
      end

      it 'should have the grand parent as the root of parent' do
        @parent.root.should == @grand_parent
      end

      it 'should have the grand parent as the root of grand parent' do
        @grand_parent.root.should == @grand_parent
      end
    end

    describe 'descendants' do
      it 'should have no descendants when new' do
        a = Archetype.new

        a.descendants.should eq []
      end

      it 'should have the child as a descendant of parent' do
        @parent.descendants.should include @child
      end

      it 'should have the parent as a descendant of grand parent' do
        @grand_parent.descendants.should include @parent
      end

      it 'should have the child as a descendant of grand parent' do
        @grand_parent.descendants.should include @child
      end

      it 'should not have itself as a descendant' do
        @parent.descendants.should_not include @parent
      end
    end

    describe 'family' do
      it 'should return self as a member' do
        @parent.family.should include @parent
      end

      it 'should return all its descendants' do
        (@grand_parent.family & @grand_parent.descendants).
            should eq @grand_parent.descendants
      end
    end

    describe 'self.root_list' do
      it 'lists the root for every archetype' do
        Rails.cache.delete('archetype_roots')
        root_list = Archetype.root_list

        root_list['Child'].should == 'Grand Parent'
        root_list['Parent'].should == 'Grand Parent'
        root_list['Grand Parent'].should == 'Grand Parent'
      end
    end
  end
end
