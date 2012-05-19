class Item < ActiveRecord::Base
  belongs_to :loot_type, :inverse_of => :items
  has_many :drops, :inverse_of => :item

  has_many :items_slots
  has_many :slots, :through => :items_slots

  has_many :archetypes_items
  has_many :archetypes, :through => :archetypes_items

  validates_presence_of :name, :eq2_item_id
  validates_uniqueness_of :name, :eq2_item_id

  has_one :last_drop,
      :class_name => 'Drop',
      :order => 'created_at desc'

  def class_names
    result = nil
    archetypes.each do |archetype|
      if result
        result << ', ' + archetype.name
      else
        result = archetype.name
      end
    end
    result
  end

  def slot_names
    result = nil
    slots.each do |slot|
      if result
        result << ', ' + slot.name
      else
        result = slot.name
      end
    end
    result
  end

  def download_soe_details
    # If the ID is negative, need to add 2^32 to convert to an unsigned integer
    item_id = eq2_item_id.to_i
    if item_id < 0
      item_id = item_id + 2 ** 32
    end
    json_data = SOEData.get("/json/get/eq2/item/?id=#{item_id}&c:show=type,displayname,typeinfo.classes,typeinfo.slot_list,slot_list")
    item_details = json_data['item_list'][0]

    # if we have the wrong item name, change it!
    unless name.eql? item_details['displayname']
      update_attribute(:name, item_details['displayname'])
    end

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
          json_data = SOEData.get("/json/get/eq2/item/?displayname=#{actual_item_name}&c:show=type,displayname,typeinfo.classes,typeinfo.slot_list,slot_list")
          adornment_details = json_data['item_list'][0]
          save_slots(adornment_details)
          save_archetypes(adornment_details)
        else
          if name.match(/Gore-Imbued/)
            loot_type_name = 'Armour'
          else
            loot_type_name = 'Trash'
          end
        end
    end
    if loot_type.nil? or loot_type.name.eql? "Unknown"
      update_attribute(:loot_type, LootType.find_by_name(loot_type_name))
    end
    save unless persisted?
  end

  def self.of_type(loot_type_name)
    loot_type = LootType.find_by_name(loot_type_name)
    loot_type ? by_loot_type(loot_type.id) : []
  end

  def self.by_loot_type(loot_type_id)
    loot_type_id ? where('items.loot_type_id = ?', loot_type_id) : scoped
  end

  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= "item"
    xml_attributes = self.attributes
    xml_attributes["drops"] = self.drops
    xml_attributes["slots"] = self.slots
    xml_attributes.to_xml(to_xml_opts)
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
