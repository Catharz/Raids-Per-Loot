module PointsCalculator
  def loot_rate(loot_type)
    calculate_loot_rate(raids.count, items.of_type(loot_type).count)
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
end