include RemoteConnectionHelper

# @author Craig Read
#
# SonyItemUpdater manages retrieving item details
# from http://data.soe.com and storing them in ExternalData
class SonyItemUpdater
  @queue = :sony_item_updater

  def self.perform(item_id)
    item = Item.find(item_id)
    raise Exception, 'Internet connection unavailable.' unless internet_connection?

    item_details = SonyDataService.new.item_data(item.eq2_item_id, 'json')
    if item_details
      loot_type_name = item_details['type']
      case loot_type_name
        when 'Armor'
          loot_type_name = 'Armour'
          save_archetypes(item, item_details)
          save_slots(item, item_details)
          loot_type_name = 'Jewellery' unless
              (%w{Neck Ear Finger Wrist Charm} & item_details['slot_list'].map { |slot| slot[:name] }).empty?
        when 'Weapon'
          save_archetypes(item, item_details)
          save_slots(item, item_details)
        when 'Shield'
          loot_type_name = 'Weapon'
          save_archetypes(item, item_details)
          save_slots(item, item_details)
        when 'Spell Scroll'
          loot_type_name = 'Spell'
          save_archetypes(item, item_details)
        else
          if item.name.match(/War Rune/)
            actual_item_name = item.name.split(': ')[1].gsub(' ', '+')
            loot_type_name = 'Adornment'
            json_data = SOEData.get("/json/get/eq2/item/?displayname=#{actual_item_name}&c:show=type,displayname,typeinfo.classes,typeinfo.slot_list,slot_list")
            adornment_details = json_data['item_list'][0]
            save_slots(item, adornment_details)
            save_archetypes(item, adornment_details)
            item_details = adornment_details
          else
            if item.name.match(/Gore-Imbued/) or item.name.match(/Cruor-Forged/) or item.name.match(/Warborne/)
              loot_type_name = 'Armour'
            else
              loot_type_name = 'Trash'
            end
          end
      end
      item.update_attribute(:loot_type, LootType.find_by_name(loot_type_name)) unless
          item.loot_type_name.eql? loot_type_name
      item.build_external_data(data: item_details)
      item.external_data.save
    end
  end

  private

  def self.save_slots(item, item_details)
    item_slots = item_details['slot_list']
    if item_slots.nil? or item_slots.empty?
      item_slots = item_details['typeinfo']['slot_list']
    end
    item_slots.each do |slot_details|
      slot_name = slot_details['displayname']
      slot_name ||= slot_details['name']
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
    item_archetypes = item_details['typeinfo']['classes']
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