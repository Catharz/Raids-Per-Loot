class Drop < ActiveRecord::Base
  require 'drop_validator'

  has_one :raid
  belongs_to :zone
  belongs_to :mob
  belongs_to :player
  belongs_to :item

  validates_presence_of :zone_name, :mob_name, :item_name, :player_name, :drop_time
  validates_uniqueness_of :zone_name, :mob_name, :item_name, :player_name, :drop_time
  validates_with DropValidator, :on => :update

  def assign_loot
    raid = Raid.find_by_zone_and_time(zone_name, drop_time)
    zone = Zone.find_by_name(zone_name)
    mob = Mob.find_by_zone_and_mob_name(zone_name, mob_name)
    player = Player.find_by_name(player_name)
    item = Item.find_by_name(item_name)

    if (raid && zone && mob && player && item)
      if !zone.drops.exists?(:zone_name => zone_name, :mob_name => mob_name, :item_name => item_name, :drop_time => drop_time)
        zone.drops << self
      end
      if !raid.drops.exists?(:zone_name => zone_name, :mob_name => mob_name, :item_name => item_name, :drop_time => drop_time)
        raid.drops << self
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
      self.errors[:base] << "A raid must exist for the entered zone and drop time to be able to create drops for it" if raid.nil?
      self.errors[:base] << "A mob must exist for the entered zone to be able to create drops for it" if mob.nil?
      self.errors[:base] << "A loot item must exist to be able to record it dropping" if item.nil?
      result = false
    end

    result
  end

  def unassign_loot
    raid = Raid.find_by_zone_and_time(zone_name, drop_time)
    zone = Zone.find_by_name(zone_name)
    mob = Mob.find_by_zone_and_mob_name(zone_name, mob_name)
    player = Player.find_by_name(player_name)
    item = Item.find_by_name(item_name)

    raid.drops.delete(self) unless raid.nil?
    zone.drops.delete(self) unless zone.nil?
    mob.drops.delete(self) unless mob.nil?
    player.drops.delete(self) unless player.nil?
    item.drops.delete(self) unless item.nil?
    self.assigned_to_player = false
    true
  end
end
