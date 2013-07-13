# @author Craig Read
#
# This class handles the calculation of points for characters and players.
module PointsCalculationHelper
  def attendance(range = {start:  nil, end: nil})
    raid_count(range).to_f / Raid.for_period(range).count.to_f * 100.00
  end

  def recalculate_loot_rates(raids_attended = 0)
    return if @inside_callback
    @inside_callback = true
    self.armour_rate = calculate_loot_rate(raids_attended, self.armour_count)
    self.jewellery_rate = calculate_loot_rate(raids_attended, self.jewellery_count)
    self.weapon_rate = calculate_loot_rate(raids_attended, self.weapons_count)
    self.attuned_rate = calculate_loot_rate(raids_attended, self.armour_count + self.jewellery_count + self.weapons_count)
    self.adornment_rate = calculate_loot_rate(raids_attended, self.adornments_count)
    self.dislodger_rate = calculate_loot_rate(raids_attended, self.dislodgers_count)
    self.mount_rate = calculate_loot_rate(raids_attended, self.mounts_count)
  end

  def raid_count(range = {start:  nil, end: nil}, aggregate_up = true)
    if aggregate_up and self.is_a? Character
      self.player.raids.for_period(range).uniq.count +
          self.player.adjustments.for_period(range).by_adjustment_type('Raids').sum(:amount)
    else
      self.raids.for_period(range).uniq.count +
          self.adjustments.for_period(range).by_adjustment_type('Raids').sum(:amount)
    end
  end

  def calculate_loot_rate(event_count, item_count)
    return 0 if event_count.nil? or item_count.nil?
    (Float(event_count) / (Float(item_count) + 1.0) * 100.00).round / 100.00
  end

  def first_drop
    drops.order('drop_time').first
  end

  def last_drop
    drops.order('drop_time desc').first
  end

  def first_instance
    instances.order('start_time').first
  end

  def last_instance
    instances.order('start_time desc').first
  end

  def first_raid
    raids.order('raid_date').first
  end

  def last_raid
    raids.order('raid_date desc').first
  end

  def first_raid_date
    first_raid ? first_raid.raid_date.strftime('%Y-%m-%d') : nil
  end

  def last_raid_date
    last_raid ? last_raid.raid_date.strftime('%Y-%m-%d') : nil
  end
end