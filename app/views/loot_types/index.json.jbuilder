json.array! @loot_types do |loot_type|
  json.loot_type do
    json.extract! loot_type, :created_at, :default_loot_method, :id, :name, :updated_at
  end
end
