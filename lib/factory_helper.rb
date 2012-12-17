module FactoryHelper
  def self.give_me_difficulty(difficulty_name, rating = 1)
    difficulty = Difficulty.find_by_name(difficulty_name)
    difficulty ||= Difficulty.create(:name => difficulty_name, :rating => rating)
    difficulty
  end

  def self.give_me_zone(zone_name, difficulty)
    zone = Zone.find_by_name(zone_name)
    zone ||= Zone.create!(:name => zone_name, :difficulty => give_me_difficulty(difficulty))
    zone
  end

  def self.give_me_raid(raid_date)
    raid = Raid.find_by_raid_date(raid_date)
    raid ||= Raid.create!(:raid_date => raid_date)
    raid
  end

  def self.give_me_instance(zone_name, raid_time)
    start_time = DateTime.parse(raid_time)
    zone = give_me_zone(zone_name, 'Easy')
    raid = give_me_raid(raid_time)
    instance = Instance.last(:conditions => ["zone_id = ? AND raid_id = ? AND start_time <= ?", zone.id, raid.id, raid_time])
    instance ||= Instance.create!(raid: raid, zone: zone, start_time: start_time)
    instance
  end

  def self.give_me_mob(zone_name, mob_name, difficulty)
    zone = give_me_zone(zone_name, difficulty)
    mob = zone.mobs.where(:name => mob_name).first
    mob ||= zone.mobs.create!(:name => mob_name)
    mob
  end

  def self.give_me_player(player_name)
    player = Player.find_by_name(player_name)
    player ||= Player.create!(:name => player_name)
    player
  end

  def self.give_me_item(item_name, eq2_item_id)
    item = Item.find_by_name(item_name)
    item ||= Item.create!(:name => item_name, :eq2_item_id => eq2_item_id)
    item
  end
end