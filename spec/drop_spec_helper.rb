require 'item_spec_helper'
require 'mob_spec_helper'
require 'loot_type_spec_helper'
require 'raid_spec_helper'

module DropSpecHelper
  include ItemSpecHelper, LootTypeSpecHelper, MobSpecHelper, RaidSpecHelper

  # These items must exist or the Drop will not be valid
  def create_drop_dependencies
    raid_date = Date.parse('2012-01-03')
    start_time = DateTime.parse('03/01/2012 13:00+11:00')

    progression = RaidType.find_by_name('Progression') ||
        FactoryGirl.create(:raid_type, name: 'Progression')

    raid = Raid.
        find_by_raid_date_and_raid_type_id(raid_date, progression.id) ||
        FactoryGirl.create(:raid, raid_date: raid_date, raid_type: progression)

    instance = Instance.
        find_by_raid_id_and_start_time(raid.id, start_time) ||
        FactoryGirl.create(:instance, raid_id: raid.id, start_time: start_time)

    zone = Zone.find_by_name('Wherever') ||
        FactoryGirl.create(:zone, name: 'Wherever')

    mob = Mob.find_by_name_and_zone_id('Whoever', zone.id) ||
        FactoryGirl.create(:mob, name: 'Whoever', zone_id: zone.id)

    armour = LootType.find_by_name('Armour')
    spell = LootType.find_by_name('Spell')
    trash = LootType.find_by_name('Trash')
    trade_skill = LootType.find_by_name('Trade Skill Component')

    armour_item = FactoryGirl.create(:item, loot_type_id: armour.id)
    spell_item = FactoryGirl.create(:item, loot_type_id: spell.id)
    trash_item = FactoryGirl.create(:item, loot_type_id: trash.id)
    trade_skill_item = FactoryGirl.create(:item, loot_type_id: trade_skill.id)

    rank = Rank.find_by_name('Main')
    player = FactoryGirl.create(:player, name: 'Me', rank_id: rank.id)

    archetype = Archetype.find_by_name('Scout')
    character = FactoryGirl.create(:character, name: 'Me', player_id: player.id,
                                   archetype_id: archetype.id, char_type: 'm')

    drop_time = DateTime.parse('03/01/2012 14:00+11:00')

    {
        raid: raid, instance: instance,
        zone: zone, mob: mob,
        armour_loot_type: armour, armour_item: armour_item,
        spell_loot_type: spell, spell_item: spell_item,
        trash_loot_type: trash, trade_skill_loot_type: trade_skill,
        trash_item: trash_item, trade_skill_item: trade_skill_item,
        rank: rank, player: player,
        character: character, archetype: archetype,
        drop_time: drop_time
    }
  end

  def valid_attributes(options = {})
    @drop_details ||= create_drop_dependencies
    {instance_id: @drop_details[:instance].id,
     zone_id: @drop_details[:zone].id,
     mob_id: @drop_details[:mob].id,
     item_id: @drop_details[:armour_item].id,
     loot_type_id: @drop_details[:armour_loot_type].id,
     character_id: @drop_details[:character].id,
     loot_method: 't',
     chat: 'blah blah blah',
     drop_time: @drop_details[:drop_time]}.merge!(options)
  end

  def create_drops(character, drop_counts = {})
    drop_list = []
    zone = mock_model(Zone, FactoryGirl.attributes_for(:zone))
    mob = create_mob(zone)
    drop_counts.each_key { |loot_type_name|
      loot_type = mock_model(LootType, name: loot_type_name)
      count = drop_counts[loot_type_name]
      drops = Array.new(count) { |n|
        item = mock_model(Item, FactoryGirl.attributes_for(:item).merge!(
            loot_type_id: loot_type.id
        ))
        drop = mock_model(Drop, FactoryGirl.attributes_for(:drop).merge!(
            item_id: item.id, loot_type_id: loot_type.id
        ))
        drop.stub(:raid).and_return(create_raid)
        drop.stub(:zone).and_return(zone)
        drop.stub(:mob).and_return(mob)
        drop.stub(:instance).and_return(create_instances([drop.raid],
                                                         [drop.zone]))
        drop.stub(:loot_type).and_return(create_loot_type('Armour'))
        drop.stub(:character).and_return(character)
        drop.stub(:item).and_return(item)
        drop.stub(:loot_method_name).and_return('Need')
        drop
      }
      drop_list << drops
    }
    drop_list.flatten
  end

  def drop_as_json(drop)
    {'sEcho' => 0,
     'iTotalRecords' => 1,
     'iTotalDisplayRecords' => 1,
     'aaData' => [
         {
             '0' => '<a href="/items/' + drop.item_id.to_s +
                 '" class="itemPopupTrigger">' + drop.item_name + '</a>',
             '1' => drop.character_name,
             '2' => drop.loot_type_name,
             '3' => drop.zone_name,
             '4' => drop.mob_name,
             '5' => '2013-12-25T18:00:00+11:00',
             "6" => drop.loot_method_name,
             '7' => '<a href="/drops/' +
                 drop.id.to_s +
                 '" class="table-button">Show</a>',
             '8' => '<a href="/drops/' +
                 drop.id.to_s +
                 '/edit" class="table-button">Edit</a>',
             '9' => '<a href="/drops/' +
                 drop.id.to_s +
                 '" class="table-button" data-confirm="Are you sure?" ' +
                 'data-method="delete" rel="nofollow">Destroy</a>',
             'DT_RowId' => drop.item.id
         }
     ]
    }
  end
end