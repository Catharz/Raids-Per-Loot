class Drop < ActiveRecord::Base
  belongs_to :instance
  belongs_to :zone
  belongs_to :mob
  belongs_to :player
  belongs_to :item

  scope :of_type, lambda {|loot_type| where(:loot_type_id => LootType.find_by_name(loot_type).id) }

  validates_presence_of :zone_name, :mob_name, :item_name, :player_name, :drop_time
  validates_uniqueness_of :drop_time, :scope => [:zone_name, :mob_name, :item_name, :player_name]
  validates_associated :zone, :mob, :player, :item, :instance, :on => :update, :message => "Must Exist!"
  #validates_with DropValidator, :on => :update

  def self.by_instance(instance_id)
    instance_id ? where('instance_id = ?', instance_id) : scoped
  end

  def self.by_zone(zone_id)
    zone_id ? where('zone_id = ?', zone_id) : scoped
  end

  def self.by_mob(mob_id)
    mob_id ? where('mob_id = ?', mob_id) : scoped
  end

  def self.by_player(player_id)
    player_id ? where('player_id = ?', player_id) : scoped
  end

  def self.by_item(item_id)
    item_id ? where('item_id = ?', item_id) : scoped
  end

  def assign_loot
    instance = Instance.find_by_zone_and_time(zone_name, drop_time)
    zone = Zone.find_by_name(zone_name)
    mob = Mob.find_by_zone_and_mob_name(zone_name, mob_name)
    player = Player.find_by_name(player_name)
    item = Item.find_by_name(item_name)

    if (instance && zone && mob && player && item)
      if !zone.drops.exists?(:zone_name => zone_name, :mob_name => mob_name, :item_name => item_name, :drop_time => drop_time)
        zone.drops << self
      end
      if !instance.drops.exists?(:zone_name => zone_name, :mob_name => mob_name, :item_name => item_name, :drop_time => drop_time)
        instance.drops << self
      end
      if !mob.drops.exists?(:zone_name => zone_name, :mob_name => mob_name, :item_name => item_name, :drop_time => drop_time)
        mob.drops << self
      end
      if !player.drops.exists?(:zone_name => zone_name, :mob_name => mob_name, :item_name => item_name, :drop_time => drop_time)
        player.drops << self
      end
      if !item.drops.exists?(:zone_name => zone_name, :mob_name => mob_name, :item_name => item_name, :drop_time => drop_time)
        item.drops << self
      end
      result = true
      self.assigned_to_player = true
    else
      self.errors[:base] << "A valid player must exist to be able to assign drops to them" if player.nil?
      self.errors[:base] << "A valid zone must exist to be able to create drops for it" if zone.nil?
      self.errors[:base] << "An instance must exist for the entered zone and drop time to be able to create drops for it" if instance.nil?
      self.errors[:base] << "A mob must exist for the entered zone to be able to create drops for it" if mob.nil?
      self.errors[:base] << "A loot item must exist to be able to record it dropping" if item.nil?
      result = false
    end

    result and save
  end

  def unassign_loot
    instance = Instance.find_by_zone_and_time(zone_name, drop_time)
    zone = Zone.find_by_name(zone_name)
    mob = Mob.find_by_zone_and_mob_name(zone_name, mob_name)
    player = Player.find_by_name(player_name)
    item = Item.find_by_name(item_name)

    instance.drops.delete(self) unless instance.nil?
    zone.drops.delete(self) unless zone.nil?
    mob.drops.delete(self) unless mob.nil?
    player.drops.delete(self) unless player.nil?
    item.drops.delete(self) unless item.nil?
    self.assigned_to_player = false
    self.instance_id, self.zone_id, self.mob_id, self.player_id, self.item_id = nil
    self.save
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
end
