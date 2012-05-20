class Drop < ActiveRecord::Base
  belongs_to :instance, :inverse_of => :drops, :touch => true
  belongs_to :zone, :inverse_of => :drops, :touch => true
  belongs_to :mob, :inverse_of => :drops, :touch => true
  belongs_to :character, :inverse_of => :drops, :touch => true
  belongs_to :item, :inverse_of => :drops, :touch => true
  belongs_to :loot_type, :inverse_of => :drops, :touch => true

  scope :of_type, lambda {|loot_type| where(:loot_type_id => LootType.find_by_name(loot_type).id) }

  validates_uniqueness_of :drop_time, :scope => [:instance_id, :zone_id, :mob_id, :item_id, :character_id]
  validates_format_of :loot_method, :with => /n|r|b|t/ # Need, Random, Bid, Trash

  # If the character received loot via "need", make sure all of the relationships are setup
  with_options :if => :needed do
    validate :relationships_exist
    validates_presence_of :zone_id, :mob_id, :item_id, :character_id, :loot_type_id, :drop_time, :loot_method
  end

  def self.by_instance(instance_id)
    instance_id ? where('instance_id = ?', instance_id) : scoped
  end

  def self.by_zone(zone_id)
    zone_id ? where('zone_id = ?', zone_id) : scoped
  end

  def self.by_mob(mob_id)
    mob_id ? where('mob_id = ?', mob_id) : scoped
  end

  def self.by_character(character_id)
    character_id ? where('character_id = ?', character_id) : scoped
  end

  def self.by_player(player_id)
    player_id ? includes(:character => :player).where('characters.player_id = ?', player_id) : scoped
  end

  def self.by_item(item_id)
    item_id ? where('item_id = ?', item_id) : scoped
  end

  def utc_time(date_time)
    TZInfo::Timezone.get('Australia/Melbourne').utc_time(date_time)
  end

  def local_time(date_time)
    TZInfo::Timezone.get('Australia/Melbourne').local_time(date_time)
  end

  def loot_type_name
    if self.item
      self.item.loot_type ? self.item.loot_type.name : "Unknown"
    else
      "Unknown"
    end
  end

  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= "drop"
    xml_attributes = self.attributes
    xml_attributes.to_xml(to_xml_opts)
  end

  protected
  def needed
    loot_method.eql? "n"
  end

  def relationships_exist
    errors.add(:zone_id, "doesn't exist") unless Zone.exists?(zone_id)
    errors.add(:mob_id, "doesn't exist") unless Mob.exists?(mob_id)
    errors.add(:item_id, "doesn't exist") unless Item.exists?(item_id)
    errors.add(:character_id, "doesn't exist") unless Character.exists?(character_id)
    errors.add(:loot_type_id, "doesn't exist") unless LootType.exists?(loot_type_id)
  end
end
