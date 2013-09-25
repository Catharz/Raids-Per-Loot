json.raid do
  json.extract! @raid, :created_at, :id, :raid_date, :raid_type_id, :updated_at,
                :players, :characters, :instances, :kills, :drops
end