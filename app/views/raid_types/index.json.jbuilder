json.array! @raid_types do |raid_type|
  json.raid_type do
    json.extract! raid_type, :id, :name, :raid_counted, :raid_points, :loot_counted, :loot_cost, :updated_at, :created_at
  end
end
