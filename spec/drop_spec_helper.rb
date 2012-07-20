require 'item_spec_helper'
require 'mob_spec_helper'
require 'loot_type_spec_helper'
require 'raid_spec_helper'
require 'zone_spec_helper'

module DropSpecHelper
  include ItemSpecHelper, LootTypeSpecHelper, MobSpecHelper, RaidSpecHelper, ZoneSpecHelper

  #These items must exist or the Drop will not be valid
  def create_drop_dependencies
    @drop_time = DateTime.parse("03/01/2012 2:00PM")
    @item = FactoryGirl.create(:item, :name => "Whatever", :eq2_item_id => "blah")
    main = FactoryGirl.create(:rank, :name => "Main")
    @player = FactoryGirl.create(:player, :name => "Me", :rank => main)
    @archetype = FactoryGirl.create(:archetype, :name => "Scout")
    @character = FactoryGirl.create(:character, :name => "Me", :player_id => @player.id, :archetype_id => @archetype.id, :char_type => "m")
    @loot_type = FactoryGirl.create(:loot_type, :name => "Spell")

    @zone = FactoryGirl.create(:zone, :name => "Wherever")
    @mob = FactoryGirl.create(:mob, :name => "Whoever", :zone_id => @zone.id)
    @raid = FactoryGirl.create(:raid, :raid_date => Date.parse("2012-01-03"))
    @instance = FactoryGirl.create(:instance, :raid_id => @raid.id, :start_time => DateTime.parse("03/01/2012 1:00PM"))
  end

  def valid_attributes(options = {})
    {:instance_id => @instance.id,
     :zone_id => @zone.id,
     :mob_id => @mob.id,
     :item_id => @item.id,
     :loot_type_id => @loot_type.id,
     :character_id => @character.id,
     :loot_method => "t",
     :drop_time => @drop_time}.merge!(options)
  end

  def valid_drop_attributes(options = {})
    {:zone_id => 1,
     :mob_id => 1,
     :instance_id => 1,
     :loot_type_id => 1,
     :item_id => 1,
     :character_id => 1,
     :drop_time => DateTime.now,
     :loot_method => "n"
    }.merge!(options)
  end

  def add_drop(character, item_name, loot_type_name)
    loot_type = mock_model(LootType, :name => loot_type_name)
    item = mock_model(Item, valid_item_attributes.merge!(:eq2_item_id => "123", :name => item_name))
    character.stub!(:drops).and_return([mock_model(Drop, valid_drop_attributes.merge!(:loot_type_id => loot_type.id, :item_id => item.id))])
  end

  def create_drops(character, drop_counts = {})
    drop_list = []
    drop_counts.each_key {|loot_type_name|
      count = drop_counts[loot_type_name]
      unless count.eql? 0
        loot_type = mock_model(LootType, :name => loot_type_name)
        drops = (1..count).to_a
        drops.each do |n|
          zone = create_zone
          mob = create_mob(zone)
          item = mock_model(Item, :eq2_item_id => "#{character.name} #{loot_type_name} item #{n}", :name => "#{character.name} #{loot_type_name} item #{n}", :loot_type => loot_type)

          drop = mock_model(Drop, valid_drop_attributes)
          drop.stub!(:raid).and_return(create_raid)
          drop.stub!(:zone).and_return(zone)
          drop.stub!(:mob).and_return(mob)
          drop.stub!(:instance).and_return(create_instances([drop.raid], [drop.zone]))
          drop.stub!(:loot_type).and_return(create_loot_type("Armour"))
          drop.stub!(:character).and_return(character)
          drop.stub!(:item).and_return(item)
          drop.stub!(:loot_method_name).and_return("Need")

          drop_list << drop
        end
      end
    }
    drop_list
  end
end