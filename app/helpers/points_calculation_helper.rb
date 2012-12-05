module PointsCalculationHelper
  def attendance(range = {start:  nil, end: nil})
    raid_count(range).to_f / Raid.for_period(range).count.to_f * 100.00
  end

  def recalculate_loot_rates
    self.armour_rate = loot_rate("Armour")
    self.jewellery_rate = loot_rate("Jewellery")
    self.weapon_rate = loot_rate("Weapon")
    self.save
  end

  def raid_count(range = {start:  nil, end: nil})
    self.raids.for_period(range).uniq.count + self.adjustments.for_period(range).by_adjustment_type("Raids").sum(:amount)
  end

  def instance_count
    self.instances.count + self.adjustments.by_adjustment_type("Instances").sum(:amount)
  end

  def armour_count
    self.item_count("Armour")
  end

  def jewellery_count
    self.item_count("Jewellery")
  end

  def weapon_count
    self.item_count("Weapon")
  end

  def item_count(loot_type)
    self.items.of_type(loot_type).count + self.adjustments.by_adjustment_type(loot_type).sum(:amount)
  end

  def loot_rate(loot_type)
    calculate_loot_rate(raid_count, item_count(loot_type))
  end

  def calculate_loot_rate(event_count, item_count)
    (Float(event_count) / (Float(item_count) + 1.0) * 100.00).round / 100.00
  end

  def first_drop
    drops.order("drop_time").first
  end

  def last_drop
    drops.order("drop_time desc").first
  end

  def first_instance
    instances.order("start_time").first
  end

  def last_instance
    instances.order("start_time desc").first
  end

  def first_raid
    raids.order("raid_date").first
  end

  def last_raid
    raids.order("raid_date desc").first
  end

  def first_raid_date
    first_raid ? first_raid.raid_date.strftime("%Y-%m-%d") : "Never"
  end

  def last_raid_date
    first_raid ? first_raid.raid_date.strftime("%Y-%m-%d") : "Never"
  end
end