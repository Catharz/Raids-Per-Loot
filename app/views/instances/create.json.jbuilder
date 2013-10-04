json.instance do
  json.extract! @instance, :created_at, :id, :raid_id, :start_time, :updated_at, :zone_id, :zone_name, :kills,
                :players, :characters, :drops
end