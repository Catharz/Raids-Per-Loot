include RemoteConnectionHelper

# @author Craig Read
#
# SonyItemUpdater manages retrieving item details
# from http://data.soe.com and storing them in ExternalData
class SonyItemUpdater
  @queue = :sony_item_updater

  def self.perform(item_id)
    raise Exception, 'Internet connection unavailable.' unless internet_connection?

    item = Item.find(item_id)
    item_details = SonyDataService.new.item_data(item.eq2_item_id, 'json')

    if item_details
      loot_type_name = actual_loot_type_name(item, item_details)
      item_details = get_war_rune_details(item) if loot_type_name == 'Adornment'

      save_archetypes(item, item_details) if %w{Adornment Armour Jewellery Weapon Spell}.include? loot_type_name
      save_slots(item, item_details) if %w{Adornment Armour Jewellery Weapon}.include? loot_type_name
      update_loot_type(item, loot_type_name)
      save_external_data(item, item_details)
    end
  end

  private

  def self.actual_loot_type_name(item, item_details)
    loot_type_name = item_details.fetch('type', 'Trash')
    return 'Adornment' if item.name.match(/War Rune/)
    return 'Weapon' if loot_type_name == 'Shield'
    return 'Spell' if loot_type_name == 'Spell Scroll'
    if loot_type_name == 'Armor'
      if (%w{Neck Ear Finger Wrist Charm} & item_details.fetch('slot_list', []).map { |slot| slot[:name] }).empty?
        return 'Armour'
      else
        return 'Jewellery'
      end
    end
    return 'Armour' if item.name.match(/Gore-Imbued|Cruor-Forged|Warborne/)

    loot_type_name = 'Trash' unless %w{Adornment Armour Jewellery Weapon Spell}.include? loot_type_name
    loot_type_name
  end

  def self.update_loot_type(item, loot_type_name)
    unless item.loot_type_name.eql? loot_type_name
      item.update_attribute(:loot_type, LootType.find_by_name(loot_type_name))
    end
  end

  def self.save_external_data(item, item_details)
    item.build_external_data(data: item_details)
    item.external_data.save
  end

  def self.get_war_rune_details(item)
    actual_item_name = item.name.split(': ')[1].gsub(' ', '+')
    params = [
        "displayname=#{actual_item_name}",
        'c:show=type,displayname,typeinfo.classes,typeinfo.slot_list,slot_list'
    ]
    json_data = SOEData.get("/json/get/eq2/item/?#{params.join('&')}")
    adornment_details = json_data.fetch('item_list', [{}]).first
    adornment_details
  end

  def self.save_slots(item, item_details)
    item_slots = item_details.fetch('slot_list', [])
    item_slots = item_details.fetch('typeinfo', {}).fetch('slot_list', []) if item_slots.empty?
    item_slots.each do |slot_details|
      slot_name = slot_details['displayname'] || slot_details['name']
      unless slot_name.nil?
        slot = Slot.find_or_create_by_name(slot_name)
        unless slot.nil? or item.slots.include? slot
          items_slot = item.items_slots.create(:slot => slot)
          items_slot.save
        end
      end
    end
  end

  def self.save_archetypes(item, item_details)
    #item_archetypes = item_details['typeinfo']['classes']
    item_archetypes = item_details.fetch('typeinfo', {}).fetch('classes', {})
    item_archetypes.each do |key, val|
      archetype_name = key.capitalize
      archetype = Archetype.find_by_name(archetype_name)
      unless item.archetypes.include? archetype
        archetype_item = item.archetypes_items.create(:archetype => archetype)
        archetype_item.save
      end
    end
  end
end