class Item < ActiveRecord::Base
  has_many :drops
  has_and_belongs_to_many :slots
  has_and_belongs_to_many :archetypes
  belongs_to :loot_type
  validates_presence_of :name, :eq2_item_id
  validates_uniqueness_of :name, :eq2_item_id

  has_one :last_drop,
      :class_name => 'Drop',
      :order => 'drops.drop_time desc'

  scope :of_type, lambda {|loot_type| LootType.find_by_name(loot_type) ? where(:loot_type_id => LootType.find_by_name(loot_type).id) : [] }

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

  def self.by_loot_type(loot_type_id)
    loot_type_id ? where('loot_type_id = ?', loot_type_id) : scoped
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
end
