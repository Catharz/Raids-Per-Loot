require 'spec_helper'
require 'drop_spec_helper'

describe Drop do
  include DropSpecHelper

  describe "#loot_method_name" do
    it "should return 'Need' when loot_method is 'n'" do
      create_drop_dependencies
      priest = FactoryGirl.create(:archetype, :name => 'Priest')
      FactoryGirl.create(:archetypes_item, :archetype_id => priest.id, :item_id => @item.id)
      drop = FactoryGirl.create(:drop, valid_attributes.merge!(:loot_method => 'n'))

      drop.loot_method_name.should eq 'Need'
    end

    it "should return 'Trash' when loot_method is 't'" do
      create_drop_dependencies
      priest = FactoryGirl.create(:archetype, :name => 'Priest')
      FactoryGirl.create(:archetypes_item, :archetype_id => priest.id, :item_id => @item.id)
      drop = FactoryGirl.create(:drop, valid_attributes.merge!(:loot_method => 't'))

      drop.loot_method_name.should eq 'Trash'
    end

    it "should return 'Random' when loot_method is 'r'" do
      create_drop_dependencies
      priest = FactoryGirl.create(:archetype, :name => 'Priest')
      FactoryGirl.create(:archetypes_item, :archetype_id => priest.id, :item_id => @item.id)
      drop = FactoryGirl.create(:drop, valid_attributes.merge!(:loot_method => 'r'))

      drop.loot_method_name.should eq 'Random'
    end

    it "should return 'Bid' when loot_method is 'b'" do
      create_drop_dependencies
      priest = FactoryGirl.create(:archetype, :name => 'Priest')
      FactoryGirl.create(:archetypes_item, :archetype_id => priest.id, :item_id => @item.id)
      drop = FactoryGirl.create(:drop, valid_attributes.merge!(:loot_method => 'b'))

      drop.loot_method_name.should eq 'Bid'
    end
  end
end