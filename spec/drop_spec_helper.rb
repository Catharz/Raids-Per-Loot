module DropSpecHelper
  def valid_drop_attributes(options = {})
    zone = options[:zone_id] ? Zone.find(options[:zone_id]) : Zone.create(:name => "Wherever")
    raid = options[:raid_id] ? Raid.find(optinos[:raid_id]) : Raid.create(:raid_date => Date.new)
    instance = options[:instance_id] ? Instance.find(options[:instance_id]) : Instance.create(:zone_id => zone.id, :raid_id => raid.id, :start_time => raid.raid_date + 18.hours, :end_time => raid.raid_date + 20.hours)
    mob = options[:mob_id] ? Mob.find(options[:mob_id]) : Mob.create(:name => "Whoever", :zone_id => zone.id)
    armour = options[:loot_type_id] ? LootType.find(options[:loot_type_id]) : LootType.create(:name => "Armour")
    item = options[:item_id] ? Item.find(options[:item_id]) : Item.create(:eq2_item_id => "123", :name => "Tin Foil Hat", :loot_type_id => armour.id)
    character = options[:character_id] ? Character.find(options[:character_id]) : Character.create(:name => "Looter", :archetype_id => Archetype.find_or_create_by_name("Mage"), :char_type => "m")
    drop_time = options[:drop_time] ? DateTime.parse(options[:drop_time]) : instance.start_time + 10.minutes
    loot_method = options[:loot_method] ? options[:loot_method] : 'n'

    {:zone_id => zone.id,
     :mob_id => mob.id,
     :instance_id => instance.id,
     :loot_type_id => armour.id,
     :item_id => item.id,
     :character_id => character.id,
     :drop_time => drop_time,
     :loot_method => loot_method
    }.merge!(options)
  end

  def add_drop(character, loot_type_name)
    loot_type = LootType.find_or_create_by_name(loot_type_name)
    character.drops.create(valid_drop_attributes(:loot_type_id => loot_type.id))
  end
end