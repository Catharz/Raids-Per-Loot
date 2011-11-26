module FactoryHelper
  def self.give_me_zone(zone_name)
    zone = Zone.find_by_name(zone_name)
    zone = Zone.create!(:name => zone_name) unless !zone.nil?
    zone
  end

  def self.give_me_raid(zone_name, raid_time)
    zone = give_me_zone(zone_name)
    raid = Raid.find_by_zone_and_time(zone_name, raid_time)
    if raid.nil?
      raid_date = raid_time.to_date
      raid_start = raid_time
      raid_end = raid_time + 2.hours
      raid = Raid.create!(:zone => zone, :raid_date => raid_date, :start_time => raid_start, :end_time => raid_end)
    end
    raid
  end

  def self.give_me_mob(zone_name, mob_name)
    zone = give_me_zone(zone_name)
    mob = Mob.find_by_zone_and_mob_name(zone_name, mob_name)
    mob = Mob.create!(:name => mob_name) unless !mob.nil?

    zone.mobs << mob
    zone.save!
    mob.zones << zone
    mob.save!
    mob
  end

  def self.give_me_player(player_name)
    player = Player.find_by_name(player_name)
    player = Player.create!(:name => player_name) unless !player.nil?
    player
  end

  def self.give_me_item(item_name, eq2_item_id)
    item = Item.find_by_name(item_name)
    item = Item.create!(:name => item_name, :eq2_item_id => eq2_item_id) unless !item.nil?
    item
  end


end