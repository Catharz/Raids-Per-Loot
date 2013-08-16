module RaidSpecHelper
  def create_raids(num_raids)
    progression = mock_model(RaidType, name: 'Progression', raid_counted: true, raid_points: 1.0, loot_counted: true, loot_cost: 1.0)
    Array.new(num_raids) { |n| mock_model(Raid, raid_date: Date.today - num_raids.days + n.days, raid_type: progression) }
  end

  def create_raid
    create_raids(1)[0]
  end
end