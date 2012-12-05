class Item < ActiveRecord::Base
  include RemoteConnectionHelper, ArchetypesHelper

  belongs_to :loot_type, :inverse_of => :items
  has_many :drops, :inverse_of => :item

  has_many :items_slots
  has_many :slots, :through => :items_slots

  has_many :archetypes_items
  has_many :archetypes, :through => :archetypes_items

  has_one :external_data, :as => :retrievable, :dependent => :destroy

  validates_presence_of :name, :eq2_item_id
  validates_uniqueness_of :eq2_item_id, :scope => :name

  has_one :last_drop,
          :class_name => 'Drop',
          :order => 'created_at desc'

  def loot_type_name
    loot_type ? loot_type.name : "Unknown"
  end

  def fetch_soe_item_details(format = "json")
    #TODO: Refactor this out and get it into a central class or gem for dealing with Sony Data
    if internet_connection?
      item_details = soe_data(format)

      if item_details
        loot_type_name = item_details['type']
        case loot_type_name
          when 'Armor'
            loot_type_name = 'Armour'
            save_archetypes(item_details)
            save_slots(item_details)
            loot_type_name = 'Jewellery' if %w{Neck Ear Finger Wrist Charm}.include? slots[0].name
          when 'Weapon'
            save_archetypes(item_details)
            save_slots(item_details)
          when 'Spell Scroll'
            loot_type_name = 'Spell'
            save_archetypes(item_details)
          else
            if name.match(/War Rune/)
              actual_item_name = name.split(": ")[1].gsub(" ", "+")
              loot_type_name = 'Adornment'
              json_data = SOEData.get("/s:#{APP_CONFIG["soe_query_id"]}/#{format}/get/eq2/item/?displayname=#{actual_item_name}&c:show=type,displayname,typeinfo.classes,typeinfo.slot_list,slot_list")
              adornment_details = json_data['item_list'][0]
              save_slots(adornment_details)
              save_archetypes(adornment_details)
            else
              if name.match(/Gore-Imbued/) or name.match(/Cruor-Forged/) or name.match(/Warborne/)
                loot_type_name = 'Armour'
              else
                loot_type_name = 'Trash'
              end
            end
        end
        if loot_type.nil? or loot_type.name.eql? "Unknown"
          update_attribute(:loot_type, LootType.find_by_name(loot_type_name))
        end
        build_external_data(:data => item_details)
        external_data.save unless external_data.persisted?
      else
        false
      end
    end
  end

  def class_names
    consolidate_archetypes(archetypes)
  end

  def slot_names
    if slots.empty?
      "None"
    else
      (slots.map {|a| a.name}).join(", ")
    end
  end

  def eq2wire_data
    Scraper.get("http://u.eq2wire.com/item/index/#{eq2_item_id}", ".itemd_detailwrap") if internet_connection?
  end

  def soe_data(format = "json")
    # If the ID is negative, need to add 2^32 to convert to an unsigned integer
    item_id = eq2_item_id.to_i
    if item_id < 0
      item_id = item_id + 2 ** 32
    end
    json_data = SOEData.get("/s:#{APP_CONFIG["soe_query_id"]}/#{format}/get/eq2/item/?id=#{item_id}&c:show=type,displayname,typeinfo.classes,typeinfo.slot_list,slot_list")
    json_data['item_list'][0]
  end

  def self.of_type(loot_type_name)
    loot_type = LootType.find_by_name(loot_type_name)
    loot_type ? by_loot_type(loot_type.id) : scoped
  end

  def self.by_loot_type(loot_type_id)
    loot_type_id ? where('items.loot_type_id = ?', loot_type_id) : scoped
  end

  def self.by_name(name)
    name ? where(:name => name) : scoped
  end

  def self.by_eq2_item_id(eq2_item_id)
    eq2_item_id ? where(:eq2_item_id => eq2_item_id) : scoped
  end

  def self.resolve_duplicates
    duplicates = Item.group(:name, :eq2_item_id).having(['count(items.id) > 1']).count
    duplicates.each do |k, v|
      item_name = k[0]
      eq2_item_id = k[1]
      count = v
      duplicate_list = Item.where(:name => item_name).order(:id)
      keep = duplicate_list[0]
      duplicate_list.each do |item|
        unless item.eql? keep
          item.drops.each do |drop|
            drop.update_attribute(:item_id, keep.id)
          end
          item.delete unless item.drops.count > 0
        end
      end
    end
    (Item.group(:name, :eq2_item_id).having(['count(items.id) > 1']).count).empty?
  end

  private
  def save_slots(item_details)
    item_slots = item_details['slot_list']
    if item_slots.nil? or item_slots.empty?
      item_slots = item_details['typeinfo']['slot_list']
    end
    item_slots.each do |slot_details|
      slot_name = slot_details['displayname']
      slot_name ||= slot_details['name']
      unless slot_name.nil?
        slot = Slot.find_or_create_by_name(slot_name)
        unless slot.nil? or slots.include? slot
          items_slot = items_slots.create(:slot => slot)
          items_slot.save
        end
      end
    end
  end

  def save_archetypes(item_details)
    item_archetypes = item_details['typeinfo']['classes']
    item_archetypes.each do |key, val|
      archetype_name = key.capitalize
      archetype = Archetype.find_by_name(archetype_name)
      unless archetypes.include? archetype
        archetype_item = archetypes_items.create(:archetype => archetype)
        archetype_item.save
      end
    end
  end
end
