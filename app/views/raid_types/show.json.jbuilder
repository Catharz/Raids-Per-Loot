json.raid_type do
  json.extract! @raid_type, :created_at, :id, :loot_cost, :loot_counted, :name, :raid_counted, :raid_points, :updated_at
end
